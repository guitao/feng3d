package me.feng3d.passes
{
	import flash.display3D.Context3DCompareMode;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	import me.feng3d.arcane;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.core.buffer.context3d.DepthTestBuffer;
	import me.feng3d.core.buffer.context3d.FSBuffer;
	import me.feng3d.core.buffer.context3d.ProgramBuffer;
	import me.feng3d.core.buffer.context3d.VCMatrixBuffer;
	import me.feng3d.core.buffer.context3d.VCVectorBuffer;
	import me.feng3d.debug.Debug;
	import me.feng3d.fagal.runFagalMethod;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeIDCommon;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeIDSkyBox;
	import me.feng3d.fagal.fragment.F_SkyBox;
	import me.feng3d.fagal.params.ShaderParamsCommon;
	import me.feng3d.fagal.vertex.V_SkyBox;
	import me.feng3d.textures.CubeTextureProxyBase;

	use namespace arcane;

	/**
	 * 天空盒通道
	 * @author warden_feng 2014-7-11
	 */
	public class SkyBoxPass extends MaterialPassBase
	{
		private const cameraPos:Vector.<Number> = new Vector.<Number>(4);
		private const scaleSkybox:Vector.<Number> = new Vector.<Number>(4);
		private const modelViewProjection:Matrix3D = new Matrix3D();

		private var _cubeTexture:CubeTextureProxyBase;

		public function SkyBoxPass()
		{
			super();
		}

		override protected function initBuffers():void
		{
			super.initBuffers();
			mapContext3DBuffer(Context3DBufferTypeIDCommon.TEXTURE_FS, updateTextureBuffer);
			mapContext3DBuffer(Context3DBufferTypeIDCommon.PROJECTION_VC_MATRIX, updateProjectionBuffer);
			mapContext3DBuffer(Context3DBufferTypeID.CAMERAPOS_VC_VECTOR, updateCameraPosBuffer);
			mapContext3DBuffer(Context3DBufferTypeIDSkyBox.SCALESKYBOX_VC_VECTOR, updateScaleSkyboxBuffer);
		}

		private function updateProjectionBuffer(projectionBuffer:VCMatrixBuffer):void
		{
			projectionBuffer.update(modelViewProjection, true);
		}

		private function updateCameraPosBuffer(cameraPosBuffer:VCVectorBuffer):void
		{
			cameraPosBuffer.update(cameraPos);
		}

		private function updateScaleSkyboxBuffer(scaleSkyboxBuffer:VCVectorBuffer):void
		{
			scaleSkyboxBuffer.update(scaleSkybox);
		}

		private function updateTextureBuffer(textureBuffer:FSBuffer):void
		{
			textureBuffer.update(_cubeTexture);
		}

		override protected function updateDepthTestBuffer(depthTestBuffer:DepthTestBuffer):void
		{
			super.updateDepthTestBuffer(depthTestBuffer);

			depthTestBuffer.update(false, Context3DCompareMode.LESS);
		}

		public function get cubeTexture():CubeTextureProxyBase
		{
			return _cubeTexture;
		}

		public function set cubeTexture(value:CubeTextureProxyBase):void
		{
			_cubeTexture = value;
			markBufferDirty(Context3DBufferTypeIDCommon.TEXTURE_FS);
		}

		override arcane function updateProgramBuffer(programBuffer:ProgramBuffer):void
		{
			var vertexCode:String = runFagalMethod(V_SkyBox);
			var fragmentCode:String = runFagalMethod(F_SkyBox);

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
			modelViewProjection.identity();
			modelViewProjection.append(renderable.sourceEntity.sceneTransform);
			modelViewProjection.append(camera.viewProjection);
		}

		override arcane function activate(camera:Camera3D):void
		{
			super.activate(camera);

			var pos:Vector3D = camera.scenePosition;
			cameraPos[0] = pos.x;
			cameraPos[1] = pos.y;
			cameraPos[2] = pos.z;
			cameraPos[3] = 0;

			scaleSkybox[0] = scaleSkybox[1] = scaleSkybox[2] = camera.lens.far / Math.sqrt(4);
			scaleSkybox[3] = 1;

			//通用渲染参数
			var common:ShaderParamsCommon = shaderParams.getComponent(ShaderParamsCommon.NAME);

			common.addSampleFlags(Context3DBufferTypeIDCommon.TEXTURE_FS, _cubeTexture);
		}
	}
}
