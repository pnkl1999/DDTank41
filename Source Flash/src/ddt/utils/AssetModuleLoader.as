package ddt.utils
{
	import com.pickgliss.loader.BaseLoader;
	import com.pickgliss.loader.LoaderManager;
	import com.pickgliss.loader.XMLNativeAnalyzer;
	import ddt.manager.PathManager;
	import flash.events.Event;
	import road7th.data.DictionaryData;
	
	public class AssetModuleLoader
	{
		
		public static const UI_TYPE:int = 1;
		
		public static const XML_TYPE:int = 2;
		
		public static const SWF_TYPE:int = 4;
		
		public static const XML_SWF_TYPE:int = 6;
		
		public static const UI_SWF_TYPE:int = 5;
		
		public static const UI_XML_TYPE:int = 3;
		
		public static const UI_XML_SWF_TYPE:int = 7;
		
		private static var _loaderQueue:QueueLoaderUtil = new QueueLoaderUtil();
		
		private static var _loaderData:DictionaryData = new DictionaryData();
		
		private static var _loaderList:Vector.<BaseLoader> = new Vector.<BaseLoader>();
		
		private static var _call:Function;
		
		private static var _params:Array;
		
		
		public function AssetModuleLoader()
		{
			super();
		}
		
		public static function addModelLoader(_arg_1:String, _arg_2:int) : void
		{
			var _local_3:Vector.<BaseLoader> = getLoaderResList(_arg_1,_arg_2);
			_loaderList = _loaderList.concat(_local_3);
		}
		
		public static function addRequestLoader(_arg_1:BaseLoader, _arg_2:Boolean = false) : void
		{
			if(_arg_2)
			{
				_loaderData.remove(_arg_1.id);
			}
			_loaderList.push(_arg_1);
		}
		
		public static function startLoader(_arg_1:Function = null, _arg_2:Array = null, _arg_3:Boolean = true) : void
		{
			var _local_6:int = 0;
			var _local_4:* = null;
			_loaderQueue.reset();
			_call = _arg_1;
			_params = _arg_2;
			var _local_5:int = _loaderList.length;
			_local_6 = 0;
			while(_local_6 < _local_5)
			{
				_local_4 = _loaderList[_local_6] as BaseLoader;
				if(_local_4 == null)
				{
					throw new Error("AssetModelLoader :: 加载项类型错误！请检查");
				}
				if(!_loaderData.hasKey(_local_4.id))
				{
					_loaderQueue.addLoader(_local_4);
				}
				_local_6++;
			}
			_loaderList.splice(0,_loaderList.length);
			if(_loaderQueue.length <= 0)
			{
				if(_call())
				{
					_call.apply(null,_params);
				}
			}
			else
			{
				_loaderQueue.addEventListener("complete",__onLoadComplete);
				_loaderQueue.addEventListener("close",__onLoadClose);
				_loaderQueue.start(_arg_3);
			}
		}
		
		private static function getLoaderResList(_arg_1:String, _arg_2:int) : Vector.<BaseLoader>
		{
			var _local_4:* = null;
			var _local_3:Vector.<BaseLoader> = new Vector.<BaseLoader>();
			if(PathManager.FLASHSITE == null || PathManager.FLASHSITE == "")
			{
				if(_arg_2 >> 1 & 1)
				{
					_local_4 = LoaderManager.Instance.creatLoader(PathManager.getUIConfigPath(_arg_1),2);
					_local_4.analyzer = new XMLNativeAnalyzer(null);
					_local_3.push(_local_4);
				}
			}
			if(_arg_2 >> 0 & 1)
			{
				_local_3.push(LoaderManager.Instance.creatLoader(PathManager.getMornUIPath(_arg_1),8));
			}
			if(_arg_2 >> 2 & 1)
			{
				_local_3.push(LoaderManager.Instance.creatLoader(PathManager.getSwfPath(_arg_1),4));
			}
			return _local_3;
		}
		
		private static function __onLoadComplete(_arg_1:Event) : void
		{
			var _local_2:int = 0;
			_local_2 = 0;
			while(_local_2 < _loaderQueue.loaders.length)
			{
				if(_loaderQueue.loaders[_local_2].isComplete)
				{
					_loaderData.add(_loaderQueue.loaders[_local_2].id,true);
				}
				_local_2++;
			}
			_loaderQueue.removeEventListener("complete",__onLoadComplete);
			_loaderQueue.removeEventListener("close",__onLoadClose);
			if(_call())
			{
				_call.apply(null,_params);
			}
		}
		
		private static function __onLoadClose(_arg_1:Event) : void
		{
			_loaderQueue.removeEventListener("complete",__onLoadComplete);
			_loaderQueue.removeEventListener("close",__onLoadClose);
		}
		
		public static function startCodeLoader(param1:Function = null, param2:Array = null, param3:Boolean = true, param4:String = "2.png", param5:String = "DDT_Core") : void
		{
			startLoader(param1,param2,param3);
		}
	}
}