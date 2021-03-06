package me.feng3d.animators
{
	import me.feng3d.animators.base.AnimationSetBase;
	import me.feng3d.cameras.Camera3D;
	import me.feng3d.core.base.IContext3DBufferOwner;
	import me.feng3d.core.base.renderable.IRenderable;

	/**
	 * 动画接口
	 * @author warden_feng 2015-1-30
	 */
	public interface IAnimator extends IContext3DBufferOwner
	{
		/**
		 * 获取动画集合基类
		 */
		function get animationSet():AnimationSetBase;

		/**
		 * 设置渲染状态
		 * @param stage3DProxy			显卡代理
		 * @param renderable			渲染实体
		 * @param vertexConstantOffset
		 * @param vertexStreamOffset
		 * @param camera				摄像机
		 */
		function setRenderState(renderable:IRenderable, camera:Camera3D):void;
	}
}
