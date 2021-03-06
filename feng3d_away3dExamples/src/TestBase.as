package
{
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	import me.feng.core.GlobalDispatcher;
	import me.feng.load.Load;
	import me.feng.load.LoadEvent;
	import me.feng.load.LoadEventData;
	import me.feng.load.data.LoadTaskItem;
	import me.feng3d.ConsoleExtension;

	/**
	 *
	 * @author warden_feng 2014-4-9
	 */
	public class TestBase extends Sprite
	{
		//资源根路径
		protected var rootPath:String = "http://images.feng3d.me/feng3dDemo/assets/";

		/**
		 * 资源列表
		 */
		protected var resourceList:Array;

		/** 资源字典 */
		protected var resourceDic:Dictionary;

		public function TestBase()
		{
			MyCC.initFlashConsole(this);
			new ConsoleExtension();
			loadTextures();
		}

		/**
		 * 加载纹理资源
		 */
		private function loadTextures():void
		{
			resourceDic = new Dictionary();

			Load.init();

			//加载资源
			var loadObj:LoadEventData = new LoadEventData();
			loadObj.urls = [];
			for (var i:int = 0; i < resourceList.length; i++)
			{
				loadObj.urls.push(rootPath + resourceList[i]);
			}
			loadObj.singleComplete = singleGeometryComplete;
			loadObj.allItemsLoaded = allItemsLoaded;
			GlobalDispatcher.instance.dispatchEvent(new LoadEvent(LoadEvent.LOAD_RESOURCE, loadObj));
		}

		/** 单个资源加载完毕 */
		private function singleGeometryComplete(loadData:LoadEventData, loadTaskItem:LoadTaskItem):void
		{
			var path:String = loadTaskItem.url;
			path = path.substr(rootPath.length);

			resourceDic[path] = loadTaskItem.loadingItem.content;
		}

		/**
		 * 处理全部加载完成事件
		 */
		private function allItemsLoaded(... args):void
		{
			this["init"]();
		}
	}
}
