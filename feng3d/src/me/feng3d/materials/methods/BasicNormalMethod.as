package me.feng3d.materials.methods
{
	import me.feng3d.arcane;
	import me.feng3d.core.buffer.context3d.FSBuffer;
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagal.params.ShaderParamsCommon;
	import me.feng3d.fagal.params.ShaderParamsLight;
	import me.feng3d.textures.Texture2DBase;

	use namespace arcane;

	/**
	 *
	 * @author warden_feng 2014-7-16
	 */
	public class BasicNormalMethod extends ShadingMethodBase
	{
		private var _texture:Texture2DBase;

		override protected function initBuffers():void
		{
			super.initBuffers();
			mapContext3DBuffer(Context3DBufferTypeID.NORMALTEXTURE_FS, updateNormalTextureBuffer);
		}

		private function updateNormalTextureBuffer(normalTextureBuffer:FSBuffer):void
		{
			normalTextureBuffer.update(_texture);
		}

		/**
		 * The texture containing the normals per pixel.
		 */
		public function get normalMap():Texture2DBase
		{
			return _texture;
		}

		public function set normalMap(value:Texture2DBase):void
		{
			if (Boolean(value) != Boolean(_texture) || //
				(value && _texture && (value.hasMipMaps != _texture.hasMipMaps || value.format != _texture.format))) //
			{
				invalidateShaderProgram();
			}

			_texture = value;

			markBufferDirty(Context3DBufferTypeID.NORMALTEXTURE_FS);
		}

		/**
		 * Indicates if the normal method output is not based on a texture (if not, it will usually always return true)
		 * Override if subclasses are different.
		 */
		arcane function get hasOutput():Boolean
		{
			return Boolean(_texture);
		}

		/**
		 * @inheritDoc
		 */
		override public function copyFrom(method:ShadingMethodBase):void
		{
			normalMap = BasicNormalMethod(method).normalMap;
		}

		override arcane function activate(shaderParams:ShaderParams):void
		{
			var shaderParamsLight:ShaderParamsLight = shaderParams.getComponent(ShaderParamsLight.NAME);

			shaderParamsLight.hasNormalTexture = _texture != null;

			//通用渲染参数
			var common:ShaderParamsCommon = shaderParams.getComponent(ShaderParamsCommon.NAME);
			common.addSampleFlags(Context3DBufferTypeID.NORMALTEXTURE_FS, _texture);
		}
	}
}
