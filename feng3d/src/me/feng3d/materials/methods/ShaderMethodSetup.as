package me.feng3d.materials.methods
{
	import me.feng3d.arcane;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.Context3DBufferOwner;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.events.ShadingMethodEvent;
	import me.feng3d.fagal.params.ShaderParams;

	use namespace arcane;

	/**
	 * 渲染函数设置
	 * @author warden_feng 2014-7-1
	 */
	public class ShaderMethodSetup extends Context3DBufferOwner
	{
		arcane var _normalMethod:BasicNormalMethod;
		arcane var _ambientMethod:BasicAmbientMethod;
		arcane var _diffuseMethod:BasicDiffuseMethod;
		arcane var _specularMethod:BasicSpecularMethod;
		arcane var _shadowMethod:ShadowMapMethodBase;

		/**
		 * 创建一个渲染函数设置
		 */
		public function ShaderMethodSetup()
		{
			normalMethod = new BasicNormalMethod();
			ambientMethod = new BasicAmbientMethod();
			diffuseMethod = new BasicDiffuseMethod();
			specularMethod = new BasicSpecularMethod();
		}

		/**
		 * 漫反射函数
		 */
		public function get diffuseMethod():BasicDiffuseMethod
		{
			return _diffuseMethod;
		}

		public function set diffuseMethod(value:BasicDiffuseMethod):void
		{
			if (_diffuseMethod)
			{
				_diffuseMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
				if (value)
					value.copyFrom(_diffuseMethod);
				removeChildBufferOwner(_diffuseMethod);
			}

			_diffuseMethod = value;

			if (_diffuseMethod)
			{
				_diffuseMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
				addChildBufferOwner(_diffuseMethod);
			}

			invalidateShaderProgram();
		}

		/**
		 * 镜面反射函数
		 */
		public function get specularMethod():BasicSpecularMethod
		{
			return _specularMethod;
		}

		public function set specularMethod(value:BasicSpecularMethod):void
		{
			if (_specularMethod)
			{
				_specularMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
				if (value)
					value.copyFrom(_specularMethod);
				removeChildBufferOwner(_specularMethod);
			}

			_specularMethod = value;

			if (_specularMethod)
			{
				_specularMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
				addChildBufferOwner(_specularMethod);
			}

			invalidateShaderProgram();
		}

		/**
		 * 法线函数
		 */
		public function get normalMethod():BasicNormalMethod
		{
			return _normalMethod;
		}

		public function set normalMethod(value:BasicNormalMethod):void
		{
			if (_normalMethod)
			{
				_normalMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
				if (value)
					value.copyFrom(_normalMethod);

				removeChildBufferOwner(_normalMethod);
			}

			_normalMethod = value;

			if (_normalMethod)
			{
				_normalMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
				addChildBufferOwner(_normalMethod);
			}

			invalidateShaderProgram();
		}

		/**
		 * 通知渲染程序失效
		 */
		private function invalidateShaderProgram():void
		{
			dispatchEvent(new ShadingMethodEvent(ShadingMethodEvent.SHADER_INVALIDATED));
		}

		/**
		 * 渲染程序失效事件处理函数
		 */
		private function onShaderInvalidated(event:ShadingMethodEvent):void
		{
			invalidateShaderProgram();
		}

		/**
		 * 漫反射函数
		 */
		public function get ambientMethod():BasicAmbientMethod
		{
			return _ambientMethod;
		}

		public function set ambientMethod(value:BasicAmbientMethod):void
		{
			if (_ambientMethod)
			{
				_ambientMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
				if (value)
					value.copyFrom(_ambientMethod);
				removeChildBufferOwner(_ambientMethod);
			}

			_ambientMethod = value;

			if (_ambientMethod)
			{
				_ambientMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
				addChildBufferOwner(_ambientMethod);
			}

			invalidateShaderProgram();
		}

		/**
		 * The method used to render shadows cast on this surface, or null if no shadows are to be rendered.
		 */
		public function get shadowMethod():ShadowMapMethodBase
		{
			return _shadowMethod;
		}

		public function set shadowMethod(value:ShadowMapMethodBase):void
		{
			if (_shadowMethod)
			{
				_shadowMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
				if (value)
					value.copyFrom(_shadowMethod);
				removeChildBufferOwner(_shadowMethod);
			}
			_shadowMethod = value;
			if (_shadowMethod)
			{
				_shadowMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, onShaderInvalidated);
				addChildBufferOwner(_shadowMethod);
			}
			invalidateShaderProgram();
		}

		/**
		 * 设置渲染状态
		 * @param renderable		可渲染对象
		 * @param stage3DProxy		3D舞台代理
		 * @param camera			摄像机
		 */
		public function setRenderState(renderable:IRenderable, camera:Camera3D):void
		{
			normalMethod.setRenderState(renderable, camera);
			ambientMethod.setRenderState(renderable, camera);
			diffuseMethod.setRenderState(renderable, camera);
			specularMethod.setRenderState(renderable, camera);
			shadowMethod && shadowMethod.setRenderState(renderable, camera);
		}

		/**
		 * 激活
		 * @param shaderParams		渲染参数
		 * @param stage3DProxy		3D舞台代理
		 */
		public function activate(shaderParams:ShaderParams):void
		{
			_normalMethod && _normalMethod.activate(shaderParams);
			_ambientMethod && _ambientMethod.activate(shaderParams);
			_diffuseMethod && _diffuseMethod.activate(shaderParams);
			_specularMethod && _specularMethod.activate(shaderParams);
			_shadowMethod && _shadowMethod.activate(shaderParams);
		}
	}
}
