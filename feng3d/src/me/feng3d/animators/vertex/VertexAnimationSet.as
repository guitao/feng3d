package me.feng3d.animators.vertex
{
	import me.feng3d.arcane;
	import me.feng3d.animators.AnimationType;
	import me.feng3d.animators.base.AnimationSetBase;
	import me.feng3d.fagal.params.ShaderParams;
	import me.feng3d.fagal.params.ShaderParamsAnimation;
	import me.feng3d.passes.MaterialPassBase;

	use namespace arcane;

	/**
	 * 顶点动画集合
	 * @author warden_feng 2014-5-30
	 */
	public class VertexAnimationSet extends AnimationSetBase
	{
		/**
		 * 创建一个顶点动画集合
		 */
		public function VertexAnimationSet()
		{
			super();
		}

		override arcane function activate(shaderParams:ShaderParams, pass:MaterialPassBase):void
		{
			var shaderParamsAnimation:ShaderParamsAnimation = shaderParams.getComponent(ShaderParamsAnimation.NAME);

			if (usesCPU)
				shaderParamsAnimation.animationType = AnimationType.VERTEX_CPU;
			else
				shaderParamsAnimation.animationType = AnimationType.VERTEX_GPU;
		}
	}
}
