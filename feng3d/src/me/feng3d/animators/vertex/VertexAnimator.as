package me.feng3d.animators.vertex
{
	import flash.utils.Dictionary;

	import me.feng3d.arcane;
	import me.feng3d.animators.IAnimator;
	import me.feng3d.animators.base.AnimationSetBase;
	import me.feng3d.animators.base.MultiClipAnimator;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.Geometry;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.core.base.subgeometry.SubGeometry;
	import me.feng3d.core.base.subgeometry.VertexSubGeometry;
	import me.feng3d.core.base.submesh.SubMesh;
	import me.feng3d.core.buffer.context3d.VCVectorBuffer;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeIDAnimation;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeIDCommon;

	use namespace arcane;

	/**
	 * 顶点动画
	 * @author warden_feng 2014-5-13
	 */
	public class VertexAnimator extends MultiClipAnimator implements IAnimator
	{
		private const weights:Vector.<Number> = Vector.<Number>([1, 0, 0, 0]);

		private var _vertexAnimationSet:VertexAnimationSet;
		private var _poses:Vector.<Geometry> = new Vector.<Geometry>();
		private var _activeVertexNode:VertexClipNode;
		private var _forceCPU:Boolean;

		private var _animationStates:Dictionary = new Dictionary();

		/**
		 * 创建一个顶点动画
		 * @param vertexAnimationSet 顶点动画集合
		 */
		public function VertexAnimator(vertexAnimationSet:VertexAnimationSet, forceCPU:Boolean = false)
		{
			_forceCPU = forceCPU;
			_vertexAnimationSet = vertexAnimationSet;
			if (forceCPU)
			{
				_vertexAnimationSet.cancelGPUCompatibility();
			}
		}

		public function get animationSet():AnimationSetBase
		{
			return _vertexAnimationSet;
		}

		override protected function initBuffers():void
		{
			super.initBuffers();
			mapContext3DBuffer(Context3DBufferTypeIDAnimation.WEIGHTS_VC_VECTOR, updateWeightsBuffer);
		}

		private function updateWeightsBuffer(weightsBuffer:VCVectorBuffer):void
		{
			weightsBuffer.update(weights);
		}

		/**
		 * 播放动画
		 * @param name 动作名称
		 * @param offset 时间偏移量
		 */
		public function play(name:String, offset:Number = NaN):void
		{
			if (_activeAnimationName != name)
			{
				_activeAnimationName = name;

				if (!_vertexAnimationSet.hasAnimation(name))
					throw new Error("Animation root node " + name + " not found!");

				//获取活动的骨骼状态
				_activeVertexNode = _vertexAnimationSet.getAnimation(name) as VertexClipNode;

				_numFrames = _activeVertexNode.frames.length;
				cycle = _activeVertexNode.totalDuration;
			}

			start();

			//使用时间偏移量处理特殊情况
			if (!isNaN(offset))
				reset(name, offset);
		}

		public function setRenderState(renderable:IRenderable, camera:Camera3D):void
		{
			//没有姿势时，使用默认姿势
			if (!_poses.length)
			{
				setNullPose(renderable)
				return;
			}

			// this type of animation can only be SubMesh
			var subMesh:SubMesh = SubMesh(renderable);
			var subGeom:SubGeometry = SubMesh(renderable).subGeometry;

			if (_vertexAnimationSet.usesCPU)
			{
				var subGeomAnimState:SubGeomAnimationState = _animationStates[subGeom] ||= new SubGeomAnimationState(subGeom);

				//检查动画数据
				if (subGeomAnimState.dirty)
				{
					var subGeom0:SubGeometry = _poses[uint(0)].subGeometries[subMesh._index];
					var subGeom1:SubGeometry = _poses[uint(1)].subGeometries[subMesh._index];
					morphGeometry(subGeomAnimState, subGeom0, subGeom1);
					subGeomAnimState.dirty = false;
				}
				//更新动画数据到几何体
				VertexSubGeometry(subGeom).updateVertexPositionData(subGeomAnimState.animatedVertexData);
			}
			else
			{
				var vertexSubGeom:VertexSubGeometry = VertexSubGeometry(subGeom);
//				//获取默认姿势几何体数据
				subGeom = _poses[0].subGeometries[subMesh._index] || subMesh.subGeometry;
				vertexSubGeom.updateVertexData0(subGeom.getVAData(Context3DBufferTypeIDCommon.POSITION_VA_3).concat());

				subGeom = _poses[1].subGeometries[subMesh._index] || subMesh.subGeometry;
				vertexSubGeom.updateVertexData1(subGeom.getVAData(Context3DBufferTypeIDCommon.POSITION_VA_3).concat());
			}
		}

		private function setNullPose(renderable:IRenderable):void
		{
			var subMesh:SubMesh = SubMesh(renderable);

			var subGeom:SubGeometry = SubMesh(renderable).subGeometry;
		}

		override protected function update():void
		{
			super.update();

			_poses[uint(0)] = _activeVertexNode.frames[currentFrame];
			_poses[uint(1)] = _activeVertexNode.frames[nextFrame];
			weights[uint(0)] = 1 - (weights[uint(1)] = blendWeight);

			for (var key:Object in _animationStates)
				SubGeomAnimationState(_animationStates[key]).dirty = true;
		}

		/**
		 * 几何体插值
		 * @param state 动画几何体数据
		 * @param subGeom 几何体0
		 * @param subGeom1 几何体1
		 */
		private function morphGeometry(state:SubGeomAnimationState, subGeom:SubGeometry, subGeom1:SubGeometry):void
		{
			//几何体顶点数据
			var vertexData:Vector.<Number> = subGeom.getVAData(Context3DBufferTypeIDCommon.POSITION_VA_3);
			var vertexData1:Vector.<Number> = subGeom1.getVAData(Context3DBufferTypeIDCommon.POSITION_VA_3);
			//动画顶点数据（目标数据）
			var targetData:Vector.<Number> = state.animatedVertexData;

			for (var i:int = 0; i < vertexData.length; i++)
			{
				targetData[i] = vertexData[i] * weights[0] + vertexData1[i] * weights[1];
			}
		}

	}
}
import me.feng3d.core.base.subgeometry.SubGeometry;
import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeIDCommon;


/**
 * 动画状态几何体数据
 */
class SubGeomAnimationState
{
	/**
	 * 动画顶点数据
	 */
	public var animatedVertexData:Vector.<Number>;
	public var dirty:Boolean = true;

	/**
	 * 创建一个动画当前状态的数据类(用来保存动画顶点数据)
	 */
	public function SubGeomAnimationState(subGeom:SubGeometry)
	{
		animatedVertexData = subGeom.getVAData(Context3DBufferTypeIDCommon.POSITION_VA_3).concat();
	}
}
