package me.feng3d.animators.base
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;

	import me.feng3d.core.base.Context3DBufferOwner;
	import me.feng3d.events.AnimatorEvent;
	import me.feng3d.library.assets.AssetType;
	import me.feng3d.library.assets.IAsset;

	/**
	 * 动画基类
	 * @author warden_feng 2014-5-27
	 */
	public class Animator extends Context3DBufferOwner implements IAsset
	{
		/** 上次动画时间(相对player时间) */
		private var _preTime:uint;
		/** 当前动画时间 */
		private var _time:int = 0;
		/** 动画驱动器 */
		private var _broadcaster:Sprite = new Sprite();
		/** 是否正在播放动画 */
		private var playing:Boolean = false;
		/** 播放速度 */
		private var _playbackSpeed:Number = 1;
		/** 周期时间 */
		protected var cycle:uint = uint.MAX_VALUE;
		/** 是否循环 */
		protected var _looping:Boolean = true;

		/**
		 * 创建一个动画基类
		 * @param animationSet
		 */
		public function Animator()
		{
			super();
		}

		/**
		 * 是否循环播放
		 */
		public function get looping():Boolean
		{
			return _looping;
		}

		public function set looping(value:Boolean):void
		{
			if (_looping == value)
				return;

			_looping = value;
		}

		/**
		 * 动画时间(0~周期)
		 */
		public function get time():int
		{
			return _time;
		}

		public function set time(value:int):void
		{
			if (_time == value)
				return;

			if (value > cycle)
			{
				dispatchCycleEvent();
				if (looping)
				{
					_time = value % cycle;
				}
				else
				{
					time = cycle;
					stop();
					dispatchCompleteEvent();
				}
			}
			else if (value < 0)
			{
				dispatchCycleEvent();
				if (looping)
				{
					_time = value % cycle;
					if (_time < 0)
						_time += cycle;
				}
				else
				{
					time = 0;
					stop();
					dispatchCompleteEvent();
				}
			}
			else
			{
				_time = value;
			}
		}

		/**
		 * 播放速度
		 */
		public function get playbackSpeed():Number
		{
			return _playbackSpeed;
		}

		public function set playbackSpeed(value:Number):void
		{
			_playbackSpeed = value;
		}

		/**
		 * 开始播放动画
		 */
		public function start():void
		{
			_preTime = getTimer();
			time = 0;

			playing = true;

			if (!_broadcaster.hasEventListener(Event.ENTER_FRAME))
				_broadcaster.addEventListener(Event.ENTER_FRAME, onEnterFrame);

			if (!hasEventListener(AnimatorEvent.START))
				return;

			dispatchEvent(new AnimatorEvent(AnimatorEvent.START, this));
		}

		/**
		 * 继续播放
		 */
		public function continues():void
		{
			if (playing)
				return;

			_preTime = getTimer();

			if (!_broadcaster.hasEventListener(Event.ENTER_FRAME))
				_broadcaster.addEventListener(Event.ENTER_FRAME, onEnterFrame);

			if (!hasEventListener(AnimatorEvent.START))
				return;

			dispatchEvent(new AnimatorEvent(AnimatorEvent.PLAY, this));
		}

		/**
		 * 停止动画
		 */
		public function stop():void
		{
			if (!playing)
				return;

			playing = false;

			if (_broadcaster.hasEventListener(Event.ENTER_FRAME))
				_broadcaster.removeEventListener(Event.ENTER_FRAME, onEnterFrame);

			if (!hasEventListener(AnimatorEvent.STOP))
				return;

			dispatchEvent(new AnimatorEvent(AnimatorEvent.STOP, this));
		}

		/**
		 * 重置动画
		 * @param name 动作名称
		 * @param time 动画时间
		 */
		public function reset(name:String, time:Number = 0):void
		{
			this.time = time;
		}

		/**
		 * 驱动动画
		 */
		private function onEnterFrame(event:Event = null):void
		{
			//更新动画时间
			var currentTime:Number = getTimer();
			time += (currentTime - _preTime) * playbackSpeed;
			_preTime = currentTime;

			//更新动画
			update();
		}

		/**
		 * 更新动画
		 */
		protected function update():void
		{

		}

		/**
		 * 抛出周期完成事件
		 */
		private function dispatchCycleEvent():void
		{
			if (hasEventListener(AnimatorEvent.CYCLE_COMPLETE))
				dispatchEvent(new AnimatorEvent(AnimatorEvent.CYCLE_COMPLETE, this));
		}

		/**
		 * 抛出周期完成事件
		 */
		private function dispatchCompleteEvent():void
		{
			if (hasEventListener(AnimatorEvent.COMPLETE))
				dispatchEvent(new AnimatorEvent(AnimatorEvent.COMPLETE, this));
		}

		public function get assetType():String
		{
			return AssetType.ANIMATOR;
		}
	}
}
