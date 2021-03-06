package me.feng3d.passes
{

	import flash.geom.Matrix3D;

	import me.feng3d.arcane;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.core.buffer.context3d.ProgramBuffer;
	import me.feng3d.core.buffer.context3d.VCMatrixBuffer;
	import me.feng3d.core.buffer.context3d.VCVectorBuffer;
	import me.feng3d.debug.Debug;
	import me.feng3d.fagal.runFagalMethod;
	import me.feng3d.fagal.context3dDataIds.SegmentContext3DBufferTypeID;
	import me.feng3d.fagal.fragment.F_Segment;
	import me.feng3d.fagal.vertex.V_Segment;

	use namespace arcane;

	/**
	 * 线段渲染通道
	 * @author warden_feng 2014-4-16
	 */
	public class SegmentPass extends MaterialPassBase
	{
		protected static const ONE_VECTOR:Vector.<Number> = Vector.<Number>([1, 1, 1, 1]);
		protected static const FRONT_VECTOR:Vector.<Number> = Vector.<Number>([0, 0, -1, 0]);
		private const constants:Vector.<Number> = new Vector.<Number>(4, true);

		/**
		 * 摄像机坐标系到投影坐标系变换矩阵（c：camera，p：projection）
		 */
		private const c2pMatrix:Matrix3D = new Matrix3D();
		/**
		 * 模型坐标系到摄像机坐标系变换矩阵（m：model，c：camera）
		 */
		private const m2cMatrix:Matrix3D = new Matrix3D();

		private var _thickness:Number;

		public function SegmentPass(thickness:Number)
		{
			_thickness = thickness;
			constants[1] = 1 / 255;

			super();
		}

		override protected function initBuffers():void
		{
			super.initBuffers();
			mapContext3DBuffer(SegmentContext3DBufferTypeID.SEGMENTC2PMATRIX_VC_MATRIX, updateC2pMatrixBuffer);
			mapContext3DBuffer(SegmentContext3DBufferTypeID.SEGMENTM2CMATRIX_VC_MATRIX, updateM2cMatrixBuffer);
			mapContext3DBuffer(SegmentContext3DBufferTypeID.SEGMENTONE_VC_VECTOR, updateOneBuffer);
			mapContext3DBuffer(SegmentContext3DBufferTypeID.SEGMENTFRONT_VC_VECTOR, updateFrontBuffer);
			mapContext3DBuffer(SegmentContext3DBufferTypeID.SEGMENTCONSTANTS_VC_VECTOR, updateConstantsBuffer);
		}

		private function updateConstantsBuffer(constantsBuffer:VCVectorBuffer):void
		{
			constantsBuffer.update(constants);
		}

		private function updateFrontBuffer(frontBuffer:VCVectorBuffer):void
		{
			frontBuffer.update(FRONT_VECTOR);
		}

		private function updateOneBuffer(oneBuffer:VCVectorBuffer):void
		{
			oneBuffer.update(ONE_VECTOR);
		}

		private function updateC2pMatrixBuffer(c2pMatrixBuffer:VCMatrixBuffer):void
		{
			//设置摄像机投影矩阵
			c2pMatrixBuffer.update(c2pMatrix, true);
		}

		private function updateM2cMatrixBuffer(m2cMatrixBuffer:VCMatrixBuffer):void
		{
			//设置投影矩阵
			m2cMatrixBuffer.update(m2cMatrix, true);
		}

		override arcane function updateProgramBuffer(programBuffer:ProgramBuffer):void
		{
			var vertexCode:String = runFagalMethod(V_Segment);
			var fragmentCode:String = runFagalMethod(F_Segment);

			if (Debug.agalDebug)
			{
				trace("Compiling AGAL Code:");
				trace("--------------------");
				trace(vertexCode);
				trace("--------------------");
				trace(fragmentCode);
			}

			//上传程序
			programBuffer.update(vertexCode, fragmentCode);
		}

		override arcane function render(renderable:IRenderable, camera:Camera3D):void
		{
			//线段厚度
			constants[0] = _thickness / 512;

			//摄像机最近距离
			constants[2] = camera.lens.near;

			//
			m2cMatrix.copyFrom(renderable.sourceEntity.sceneTransform);
			m2cMatrix.append(camera.inverseSceneTransform);

			c2pMatrix.copyFrom(camera.lens.matrix);
		}
	}
}
