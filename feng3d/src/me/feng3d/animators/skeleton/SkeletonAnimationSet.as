package me.feng3d.animators.skeleton
{
	import me.feng3d.arcane;
	import me.feng3d.animators.AnimationType;
	import me.feng3d.animators.base.AnimationSetBase;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagal.params.ShaderParamsAnimation;
	import me.feng3d.passes.MaterialPassBase;

	use namespace arcane;

	/**
	 * 骨骼动画集合
	 * @author warden_feng 2014-5-20
	 */
	public class SkeletonAnimationSet extends AnimationSetBase
	{
		private var _jointsPerVertex:uint;

		private var _numJoints:uint;

		/**
		 * 创建一个骨骼动画集合
		 * @param jointsPerVertex 每个顶点关联关节的数量
		 */
		public function SkeletonAnimationSet(jointsPerVertex:uint = 4)
		{
			_jointsPerVertex = jointsPerVertex;
		}

		/**
		 * 每个顶点关联关节的数量
		 */
		public function get jointsPerVertex():uint
		{
			return _jointsPerVertex;
		}

		arcane override function activate(shaderParams:ShaderParams, pass:MaterialPassBase):void
		{
			var shaderParamsAnimation:ShaderParamsAnimation = shaderParams.getComponent(ShaderParamsAnimation.NAME);

			shaderParamsAnimation.numJoints = _numJoints;
			shaderParamsAnimation.jointsPerVertex = _jointsPerVertex;

			if (usesCPU)
				shaderParamsAnimation.animationType = AnimationType.SKELETON_CPU;
			else
				shaderParamsAnimation.animationType = AnimationType.SKELETON_GPU;
		}

		public function set numJoints(value:uint):void
		{
			_numJoints = value;
		}

	}
}
