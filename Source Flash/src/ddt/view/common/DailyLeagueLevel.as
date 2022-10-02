package ddt.view.common
{
	import com.pickgliss.loader.BaseLoader;
	import com.pickgliss.loader.DisplayLoader;
	import com.pickgliss.loader.LoaderManager;
	import com.pickgliss.loader.LoaderEvent;
	import com.pickgliss.ui.core.Disposeable;
	import com.pickgliss.ui.core.ITipedDisplay;
	import com.pickgliss.utils.ObjectUtils;
	import ddt.manager.DailyLeagueManager;
	import ddt.manager.PathManager;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class DailyLeagueLevel extends Sprite implements ITipedDisplay, Disposeable
	{
		
		public static const SIZE_BIG:int = 0;
		
		public static const SIZE_SMALL:int = 1;
		
		
		private var _rankIcon:Bitmap;
		
		private var _level:int;
		
		private var _score:int = -1;
		
		private var _leagueFirst:Boolean;
		
		private var _loader:DisplayLoader;
		
		private var _tipDirctions:String;
		
		private var _tipGapH:int;
		
		private var _tipGapV:int;
		
		private var _tipStyle:String;
		
		private var _tipData:Object;
		
		private var _size:int;
		
		public function DailyLeagueLevel()
		{
			super();
		}
		
		public function set leagueFirst(_arg_1:Boolean) : void
		{
			if(this._leagueFirst == _arg_1)
			{
				return;
			}
			this._leagueFirst = _arg_1;
		}
		
		public function set score(_arg_1:int) : void
		{
			if(_arg_1 == this._score)
			{
				return;
			}
			this._score = _arg_1;
			this._level = DailyLeagueManager.Instance.getLeagueLevelByScore(this._score,this._leagueFirst).Level;
			this.updateView();
			this.updateSize();
		}
		
		private function updateView() : void
		{
			if(this._rankIcon)
			{
				if(this._rankIcon.parent)
				{
					this._rankIcon.parent.removeChild(this._rankIcon);
				}
				this._rankIcon.bitmapData.dispose();
				this._rankIcon = null;
			}
			this._loader = LoaderManager.Instance.creatLoader(PathManager.solveLeagueRankPath(this._level),BaseLoader.BITMAP_LOADER);
			this._loader.addEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
			this._loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
			LoaderManager.Instance.startLoad(this._loader);
		}
		
		public function set size(_arg_1:int) : void
		{
			this._size = _arg_1;
			this.updateSize();
		}
		
		private function updateSize() : void
		{
			if(this._size == SIZE_SMALL)
			{
				scaleX = scaleY = 0.875;
			}
			else if(this._size == SIZE_BIG)
			{
				scaleX = scaleY = 1;
			}
		}
		
		private function __onLoadComplete(_arg_1:LoaderEvent) : void
		{
			this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
			this._loader.removeEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
			if(this._loader.isSuccess)
			{
				this._rankIcon = this._loader.content as Bitmap;
				addChild(this._rankIcon);
			}
		}
		
		private function __onLoadError(_arg_1:LoaderEvent) : void
		{
			this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
			this._loader.removeEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
		}
		
		public function get tipData() : Object
		{
			return this._tipData;
		}
		
		public function set tipData(_arg_1:Object) : void
		{
			this._tipData = _arg_1;
		}
		
		public function get tipDirctions() : String
		{
			return this._tipDirctions;
		}
		
		public function set tipDirctions(_arg_1:String) : void
		{
			this._tipDirctions = _arg_1;
		}
		
		public function get tipGapH() : int
		{
			return this._tipGapH;
		}
		
		public function set tipGapH(_arg_1:int) : void
		{
			this._tipGapH = _arg_1;
		}
		
		public function get tipGapV() : int
		{
			return this._tipGapV;
		}
		
		public function set tipGapV(_arg_1:int) : void
		{
			this._tipGapV = _arg_1;
		}
		
		public function get tipStyle() : String
		{
			return this._tipStyle;
		}
		
		public function set tipStyle(_arg_1:String) : void
		{
			this._tipStyle = _arg_1;
		}
		
		public function asDisplayObject() : DisplayObject
		{
			return this;
		}
		
		public function dispose() : void
		{
			if(this._rankIcon)
			{
				ObjectUtils.disposeObject(this._rankIcon);
			}
			this._rankIcon = null;
			if(this._loader)
			{
				this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
				this._loader.removeEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
			}
			this._loader = null;
			if(parent)
			{
				parent.removeChild(this);
			}
		}
	}
}
