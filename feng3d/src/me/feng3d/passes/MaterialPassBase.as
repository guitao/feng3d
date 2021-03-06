package me.feng3d.passes
{
	import flash.display.BlendMode;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DTriangleFace;
	import flash.events.Event;

	import me.feng.error.AbstractClassError;
	import me.feng.error.AbstractMethodError;
	import me.feng3d.arcane;
	import me.feng3d.animators.base.AnimationSetBase;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.Context3DBufferOwner;
	import me.feng3d.core.base.renderable.IRenderable;
	import me.feng3d.core.buffer.context3d.BlendFactorsBuffer;
	import me.feng3d.core.buffer.context3d.CullingBuffer;
	import me.feng3d.core.buffer.context3d.DepthTestBuffer;
	import me.feng3d.core.buffer.context3d.ProgramBuffer;
	import me.feng3d.debug.Debug;
	import me.feng3d.fagal.runFagalMethod;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeIDCommon;
	import me.feng3d.fagal.fragment.F_Main;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagal.params.ShaderParamsAnimation;
	import me.feng3d.fagal.params.ShaderParamsCommon;
	import me.feng3d.fagal.params.ShaderParamsLight;
	import me.feng3d.fagal.params.ShaderParamsShadowMap;
	import me.feng3d.fagal.params.ShaderParamsTerrain;
	import me.feng3d.fagal.params.ShaderParamsWar3;
	import me.feng3d.fagal.vertex.V_Main;
	import me.feng3d.materials.lightpickers.LightPickerBase;
	import me.feng3d.materials.methods.ShaderMethodSetup;

	use namespace arcane;

	/**
	 * 纹理通道基类
	 * <p>该类实现了生成与管理渲染程序功能</p>
	 * @author warden_feng 2014-4-15
	 */
	public class MaterialPassBase extends Context3DBufferOwner
	{
		protected var _animationSet:AnimationSetBase;

		protected var _methodSetup:ShaderMethodSetup;

		protected var _blendFactorSource:String = Context3DBlendFactor.ONE;
		protected var _blendFactorDest:String = Context3DBlendFactor.ZERO;

		protected var _depthCompareMode:String = Context3DCompareMode.LESS_EQUAL;
		protected var _enableBlending:Boolean;

		private var _bothSides:Boolean;

		protected var _lightPicker:LightPickerBase;

		protected var _defaultCulling:String = Context3DTriangleFace.BACK;

		protected var _writeDepth:Boolean = true;

		public var useVertex:Boolean = true;

		protected var _smooth:Boolean = true;
		protected var _repeat:Boolean = false;
		protected var _mipmap:Boolean = true;

		protected var _numDirectionalLights:uint;

		protected var _numPointLights:uint;

		private var _shaderParams:ShaderParams;

		/**
		 * 创建一个纹理通道基类
		 */
		public function MaterialPassBase()
		{
			AbstractClassError.check(this);
		}

		/**
		 * 渲染参数
		 */
		public function get shaderParams():ShaderParams
		{
			if (_shaderParams == null)
			{
				_shaderParams = new ShaderParams();
				//在这里添加组件 显然不合适，暂时这样处理，以后整理
				_shaderParams.addComponent(new ShaderParamsCommon());
				_shaderParams.addComponent(new ShaderParamsLight());
				_shaderParams.addComponent(new ShaderParamsShadowMap());
				_shaderParams.addComponent(new ShaderParamsAnimation());
				_shaderParams.addComponent(new ShaderParamsTerrain());
				_shaderParams.addComponent(new ShaderParamsWar3());
			}
			return _shaderParams;
		}

		/**
		 * 是否平滑
		 */
		public function get smooth():Boolean
		{
			return _smooth;
		}

		public function set smooth(value:Boolean):void
		{
			if (_smooth == value)
				return;
			_smooth = value;
			invalidateShaderProgram();
		}

		/**
		 * 是否重复平铺
		 */
		public function get repeat():Boolean
		{
			return _repeat;
		}

		public function set repeat(value:Boolean):void
		{
			if (_repeat == value)
				return;
			_repeat = value;
			invalidateShaderProgram();
		}

		/**
		 * 贴图是否使用分级细化
		 */
		public function get mipmap():Boolean
		{
			return _mipmap;
		}

		public function set mipmap(value:Boolean):void
		{
			if (_mipmap == value)
				return;
			_mipmap = value;
			invalidateShaderProgram();
		}

		/**
		 * 是否开启混合模式
		 */
		public function get enableBlending():Boolean
		{
			return _enableBlending;
		}

		public function set enableBlending(value:Boolean):void
		{
			_enableBlending = value;
			markBufferDirty(Context3DBufferTypeIDCommon.BLEND_FACTORS);
			markBufferDirty(Context3DBufferTypeIDCommon.DEPTH_TEST);
		}

		/**
		 * @inheritDoc
		 */
		override protected function initBuffers():void
		{
			super.initBuffers();
			mapContext3DBuffer(Context3DBufferTypeIDCommon.CULLING, updateCullingBuffer);
			mapContext3DBuffer(Context3DBufferTypeIDCommon.BLEND_FACTORS, updateBlendFactorsBuffer);
			mapContext3DBuffer(Context3DBufferTypeIDCommon.DEPTH_TEST, updateDepthTestBuffer);
			mapContext3DBuffer(Context3DBufferTypeIDCommon.PROGRAM, updateProgramBuffer);
		}

		/**
		 * 动画数据集合
		 */
		public function get animationSet():AnimationSetBase
		{
			return _animationSet;
		}

		public function set animationSet(value:AnimationSetBase):void
		{
			if (_animationSet == value)
				return;

			_animationSet = value;

			invalidateShaderProgram();
		}

		/**
		 * 激活渲染通道
		 * @param shaderParams		渲染参数
		 * @param stage3DProxy		3D舞台代理
		 * @param camera			摄像机
		 */
		arcane function activate(camera:Camera3D):void
		{
			//通用渲染参数
			var common:ShaderParamsCommon = shaderParams.getComponent(ShaderParamsCommon.NAME);

			common.useMipmapping = _mipmap;
			common.useSmoothTextures = _smooth;
			common.repeatTextures = _repeat;

			if (_animationSet)
				_animationSet.activate(shaderParams, this);
		}

		/**
		 * 清除通道渲染数据
		 * @param stage3DProxy		3D舞台代理
		 */
		arcane function deactivate():void
		{
		}

		/**
		 * 更新动画状态
		 * @param renderable			渲染对象
		 * @param stage3DProxy			3D舞台代理
		 * @param camera				摄像机
		 */
		arcane function updateAnimationState(renderable:IRenderable, camera:Camera3D):void
		{
			renderable.animator.setRenderState(renderable, camera);
		}

		/**
		 * 渲染
		 * @param renderable			渲染对象
		 * @param camera				摄像机
		 */
		arcane function render(renderable:IRenderable, camera:Camera3D):void
		{
			throw new AbstractMethodError();
		}

		/**
		 * 标记渲染程序失效
		 */
		arcane function invalidateShaderProgram():void
		{
			markBufferDirty(Context3DBufferTypeIDCommon.PROGRAM);
		}

		/**
		 * 更新深度测试缓冲
		 * @param depthTestBuffer			深度测试缓冲
		 */
		protected function updateDepthTestBuffer(depthTestBuffer:DepthTestBuffer):void
		{
			depthTestBuffer.update(_writeDepth && !enableBlending, _depthCompareMode);
		}

		/**
		 * 更新混合因子缓冲
		 * @param blendFactorsBuffer		混合因子缓冲
		 */
		protected function updateBlendFactorsBuffer(blendFactorsBuffer:BlendFactorsBuffer):void
		{
			blendFactorsBuffer.update(_blendFactorSource, _blendFactorDest);
		}

		/**
		 * 更新剔除模式缓冲
		 * @param cullingBuffer		剔除模式缓冲
		 */
		protected function updateCullingBuffer(cullingBuffer:CullingBuffer):void
		{
			cullingBuffer.update(_bothSides ? Context3DTriangleFace.NONE : _defaultCulling);
		}

		/**
		 * 更新（编译）渲染程序
		 */
		arcane function updateProgramBuffer(programBuffer:ProgramBuffer):void
		{
			//运行顶点渲染函数
			var vertexCode:String = runFagalMethod(V_Main);
			//运行片段渲染函数
			var fragmentCode:String = runFagalMethod(F_Main);

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

		/**
		 * 灯光采集器
		 */
		arcane function get lightPicker():LightPickerBase
		{
			return _lightPicker;
		}

		arcane function set lightPicker(value:LightPickerBase):void
		{
			if (_lightPicker)
				_lightPicker.removeEventListener(Event.CHANGE, onLightsChange);
			_lightPicker = value;
			if (_lightPicker)
				_lightPicker.addEventListener(Event.CHANGE, onLightsChange);
			updateLights();
		}

		/**
		 * 灯光发生变化
		 */
		private function onLightsChange(event:Event):void
		{
			updateLights();
		}

		/**
		 * 更新灯光渲染
		 */
		protected function updateLights():void
		{
			if (_lightPicker)
			{
				_numPointLights = _lightPicker.numPointLights;
				_numDirectionalLights = _lightPicker.numDirectionalLights;
			}
			invalidateShaderProgram();
		}

		/**
		 * 设置混合模式
		 * @param value		混合模式
		 */
		public function setBlendMode(value:String):void
		{
			switch (value)
			{
				case BlendMode.NORMAL:
					_blendFactorSource = Context3DBlendFactor.ONE;
					_blendFactorDest = Context3DBlendFactor.ZERO;
					enableBlending = false;
					break;
				case BlendMode.LAYER:
					_blendFactorSource = Context3DBlendFactor.SOURCE_ALPHA;
					_blendFactorDest = Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
					enableBlending = true;
					break;
				case BlendMode.MULTIPLY:
					_blendFactorSource = Context3DBlendFactor.ZERO;
					_blendFactorDest = Context3DBlendFactor.SOURCE_COLOR;
					enableBlending = true;
					break;
				case BlendMode.ADD:
					_blendFactorSource = Context3DBlendFactor.SOURCE_ALPHA;
					_blendFactorDest = Context3DBlendFactor.ONE;
					enableBlending = true;
					break;
				case BlendMode.ALPHA:
					_blendFactorSource = Context3DBlendFactor.ZERO;
					_blendFactorDest = Context3DBlendFactor.SOURCE_ALPHA;
					enableBlending = true;
					break;
				case BlendMode.SCREEN:
					_blendFactorSource = Context3DBlendFactor.ONE;
					_blendFactorDest = Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR;
					enableBlending = true;
					break;
				default:
					throw new ArgumentError("Unsupported blend mode!");
			}
		}

		/**
		 * 是否写入到深度缓存
		 */
		public function get writeDepth():Boolean
		{
			return _writeDepth;
		}

		public function set writeDepth(value:Boolean):void
		{
			_writeDepth = value;
			markBufferDirty(Context3DBufferTypeIDCommon.DEPTH_TEST);
		}

		/**
		 * 深度比较模式
		 */
		public function get depthCompareMode():String
		{
			return _depthCompareMode;
		}

		public function set depthCompareMode(value:String):void
		{
			_depthCompareMode = value;
			markBufferDirty(Context3DBufferTypeIDCommon.DEPTH_TEST);
		}

		/**
		 * 是否双面渲染
		 */
		public function get bothSides():Boolean
		{
			return _bothSides;
		}

		public function set bothSides(value:Boolean):void
		{
			_bothSides = value;
			markBufferDirty(Context3DBufferTypeIDCommon.CULLING);
		}

		/**
		 * 渲染中是否使用了灯光
		 */
		protected function usesLights():Boolean
		{
			return (_numPointLights > 0 || _numDirectionalLights > 0);
		}
	}
}
