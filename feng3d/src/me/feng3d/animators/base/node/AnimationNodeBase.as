package me.feng3d.animators.base.node
{
	import me.feng.events.FEventDispatcher;
	import me.feng3d.arcane;
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.library.assets.IAsset;

	use namespace arcane;

	/**
	 * 动画节点基类
	 * @author warden_feng 2014-5-20
	 */
	public class AnimationNodeBase extends FEventDispatcher implements IAsset
	{
		protected var _stateClass:Class;

		private var _animationName:String;

		/**
		 * 动画节点名称
		 */
		public function get animationName():String
		{
			return _animationName;
		}

		public function set animationName(value:String):void
		{
			_animationName = value;
		}

		/**
		 * 创建一个动画节点基类
		 */		
		public function AnimationNodeBase()
		{
			super();
		}

		/**
		 * @inheritDoc
		 */
		public function get assetType():String
		{
			return AssetType.ANIMATION_NODE;
		}
	}
}
