package me.feng3d.animators.base
{

	/**
	 * 帧动画
	 * @author warden_feng 2015-1-29
	 */
	public class FrameAnimator extends Animator
	{
		protected var _numFrames:uint = 0;
		protected var _durations:Vector.<uint> = new Vector.<uint>();

		/** 是否稳定帧率 */
		public var fixedFrameRate:Boolean = true;
		/** 混合权重 */
		protected var _blendWeight:Number;
		protected var _currentFrame:uint;
		protected var _nextFrame:uint;
		/** 帧脏标记 */
		protected var _framesDirty:Boolean = true;

		/**
		 * 创建一个动画基类
		 * @param animationSet
		 */
		public function FrameAnimator()
		{
		}

		/**
		 * 当前帧编号
		 */
		public function get currentFrame():uint
		{
			if (_framesDirty)
				updateFrames();

			return _currentFrame;
		}

		/**
		 * 下一帧编号
		 */
		public function get nextFrame():uint
		{
			if (_framesDirty)
				updateFrames();

			return _nextFrame;
		}

		/**
		 * 混合权重
		 */
		public function get blendWeight():Number
		{
			if (_framesDirty)
				updateFrames();

			return _blendWeight;
		}

		override protected function update():void
		{
			_framesDirty = true;
			super.update();
		}

		/**
		 * 帧持续时间列表（ms）
		 */
		public function get durations():Vector.<uint>
		{
			return _durations;
		}

		/**
		 * 更新动画帧
		 */
		protected function updateFrames():void
		{
			_framesDirty = false;

			//修正time值在周期与0之间
			if (looping && (time >= cycle || time < 0))
			{
				time %= cycle;
				if (time < 0)
					time += cycle;
			}

			//无循环时，时间大于总周期，直接跳转到最后一帧
			if (!looping && time >= cycle)
			{
				_currentFrame = lastFrame;
				_nextFrame = lastFrame;
				_blendWeight = 0;
			}
			//无循环时，时间小于0，直接跳转到第一帧
			else if (!looping && time <= 0)
			{
				_currentFrame = 0;
				_nextFrame = 0;
				_blendWeight = 0;
			}
			//固定帧时，直接跳转到下一帧
			else if (fixedFrameRate)
			{
				var t:Number = time / cycle * lastFrame;
				_currentFrame = t;
				_blendWeight = t - _currentFrame;
				_nextFrame = _currentFrame + 1;
			}
			else
			{
				//根据实际过去的时间跳转到应当所在的帧位置
				_currentFrame = 0;
				_nextFrame = 0;

				var dur:uint = 0, frameTime:uint;

				do
				{
					frameTime = dur;
					dur += durations[nextFrame];
					_currentFrame = _nextFrame++;
				} while (time > dur);

				if (_currentFrame == lastFrame)
				{
					_currentFrame = 0;
					_nextFrame = 1;
				}

				_blendWeight = (time - frameTime) / durations[_currentFrame];
			}
		}

		/**
		 * 最后一帧编号
		 */
		public function get lastFrame():uint
		{
			return _numFrames - 1;
		}

		/**
		 * 总帧数
		 */
		public function get numFrames():uint
		{
			return _numFrames;
		}
	}
}
