package me.feng3d.passes
{
	import flash.geom.Vector3D;

	import me.feng3d.arcane;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.buffer.context3d.FCVectorBuffer;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeIDLight;
	import me.feng3d.fagal.params.ShaderParamsLight;
	import me.feng3d.lights.DirectionalLight;
	import me.feng3d.lights.PointLight;

	use namespace arcane;

	/**
	 * 超级渲染通道
	 * <p>提供灯光渲染相关信息</p>
	 * @author warden_feng 2014-7-1
	 */
	public class SuperShaderPass extends CompiledPass
	{
		/** 方向光源场景方向数据 */
		private const dirLightSceneDirData:Vector.<Number> = new Vector.<Number>();

		/** 方向光源漫反射光颜色数据 */
		private const dirLightDiffuseData:Vector.<Number> = new Vector.<Number>();

		/** 方向光源镜面反射颜色数据 */
		private const dirLightSpecularData:Vector.<Number> = new Vector.<Number>();

		/** 点光源场景位置数据 */
		private const pointLightScenePositionData:Vector.<Number> = new Vector.<Number>();

		/** 点光源漫反射光颜色数据 */
		private const pointLightDiffuseData:Vector.<Number> = new Vector.<Number>();

		/** 点光源镜面反射颜色数据 */
		private const pointLightSpecularData:Vector.<Number> = new Vector.<Number>();

		/**
		 * 创建超级渲染通道
		 */
		public function SuperShaderPass()
		{
			super();
		}

		/**
		 * @inheritDoc
		 */
		override protected function initBuffers():void
		{
			super.initBuffers();
			mapContext3DBuffer(Context3DBufferTypeIDLight.DIRLIGHTSCENEDIR_FC_VECTOR, updateDirLightSceneDirBuffer);
			mapContext3DBuffer(Context3DBufferTypeIDLight.DIRLIGHTDIFFUSE_FC_VECTOR, updateDirLightDiffuseReg);
			mapContext3DBuffer(Context3DBufferTypeIDLight.DIRLIGHTSPECULAR_FC_VECTOR, updateDirLightSpecularBuffer);
			mapContext3DBuffer(Context3DBufferTypeIDLight.POINTLIGHTSCENEPOS_FC_VECTOR, updatePointLightScenePositionBuffer);
			mapContext3DBuffer(Context3DBufferTypeIDLight.POINTLIGHTDIFFUSE_FC_VECTOR, updatePointLightDiffuseReg);
			mapContext3DBuffer(Context3DBufferTypeIDLight.POINTLIGHTSPECULAR_FC_VECTOR, updatePointLightSpecularBuffer);
		}

		private function updateDirLightSpecularBuffer(dirLightSpecularBuffer:FCVectorBuffer):void
		{
			dirLightSpecularBuffer.update(dirLightSpecularData);
		}

		private function updateDirLightDiffuseReg(dirLightDiffuseBuffer:FCVectorBuffer):void
		{
			dirLightDiffuseBuffer.update(dirLightDiffuseData);
		}

		private function updateDirLightSceneDirBuffer(dirLightSceneDirBuffer:FCVectorBuffer):void
		{
			dirLightSceneDirBuffer.update(dirLightSceneDirData);
		}

		private function updatePointLightSpecularBuffer(pointLightSpecularBuffer:FCVectorBuffer):void
		{
			pointLightSpecularBuffer.update(pointLightSpecularData);
		}

		private function updatePointLightDiffuseReg(pointLightDiffuseBuffer:FCVectorBuffer):void
		{
			pointLightDiffuseBuffer.update(pointLightDiffuseData);
		}

		private function updatePointLightScenePositionBuffer(pointLightScenePositionBuffer:FCVectorBuffer):void
		{
			pointLightScenePositionBuffer.update(pointLightScenePositionData);
		}

		/**
		 * @inheritDoc
		 */
		override arcane function activate(camera:Camera3D):void
		{
			if (_lightPicker)
			{
				var shaderParamsLight:ShaderParamsLight = shaderParams.getComponent(ShaderParamsLight.NAME);

				shaderParamsLight.numPointLights = _lightPicker.numPointLights;
				shaderParamsLight.numDirectionalLights = _lightPicker.numDirectionalLights;
			}
			super.activate(camera);
		}

		/**
		 * @inheritDoc
		 */
		override protected function updateLightConstants():void
		{
			var dirLight:DirectionalLight;
			var pointLight:PointLight;
			var sceneDirection:Vector3D;
			var scenePosition:Vector3D;
			var len:int;
			var i:uint, k:uint;

			var dirLights:Vector.<DirectionalLight> = _lightPicker.directionalLights;
			len = dirLights.length;
			for (i = 0; i < len; ++i)
			{
				dirLight = dirLights[i];
				sceneDirection = dirLight.sceneDirection;

				_ambientLightR += dirLight._ambientR;
				_ambientLightG += dirLight._ambientG;
				_ambientLightB += dirLight._ambientB;

				dirLightSceneDirData[i * 4 + 0] = -sceneDirection.x;
				dirLightSceneDirData[i * 4 + 1] = -sceneDirection.y;
				dirLightSceneDirData[i * 4 + 2] = -sceneDirection.z;
				dirLightSceneDirData[i * 4 + 3] = 1;

				dirLightDiffuseData[i * 4 + 0] = dirLight._diffuseR;
				dirLightDiffuseData[i * 4 + 1] = dirLight._diffuseG;
				dirLightDiffuseData[i * 4 + 2] = dirLight._diffuseB;
				dirLightDiffuseData[i * 4 + 3] = 1;

				dirLightSpecularData[i * 4 + 0] = dirLight._specularR;
				dirLightSpecularData[i * 4 + 1] = dirLight._specularG;
				dirLightSpecularData[i * 4 + 2] = dirLight._specularB;
				dirLightSpecularData[i * 4 + 3] = 1;
			}

			var pointLights:Vector.<PointLight> = _lightPicker.pointLights;
			len = pointLights.length;
			for (i = 0; i < len; ++i)
			{
				pointLight = pointLights[i];
				scenePosition = pointLight.scenePosition;

				_ambientLightR += pointLight._ambientR;
				_ambientLightG += pointLight._ambientG;
				_ambientLightB += pointLight._ambientB;

				pointLightScenePositionData[i * 4 + 0] = scenePosition.x;
				pointLightScenePositionData[i * 4 + 1] = scenePosition.y;
				pointLightScenePositionData[i * 4 + 2] = scenePosition.z;
				pointLightScenePositionData[i * 4 + 3] = 1;

				pointLightDiffuseData[i * 4 + 0] = pointLight._diffuseR;
				pointLightDiffuseData[i * 4 + 1] = pointLight._diffuseG;
				pointLightDiffuseData[i * 4 + 2] = pointLight._diffuseB;
				pointLightDiffuseData[i * 4 + 3] = pointLight._radius * pointLight._radius;

				pointLightSpecularData[i * 4 + 0] = pointLight._specularR;
				pointLightSpecularData[i * 4 + 1] = pointLight._specularG;
				pointLightSpecularData[i * 4 + 2] = pointLight._specularB;
				pointLightSpecularData[i * 4 + 3] = pointLight._fallOffFactor;
			}

		}
	}
}
