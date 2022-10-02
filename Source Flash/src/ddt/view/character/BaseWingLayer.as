package ddt.view.character
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.utils.ClassUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.PathManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class BaseWingLayer extends Sprite implements ILayer
   {
      
      public static const SHOW_WING:int = 0;
      
      public static const GAME_WING:int = 1;
       
      
      protected var _info:ItemTemplateInfo;
      
      protected var _callBack:Function;
      
      protected var _loader:ModuleLoader;
      
      protected var _showType:int = 0;
      
      protected var _wing:MovieClip;
      
      private var _isComplete:Boolean;
      
      public function BaseWingLayer(param1:ItemTemplateInfo, param2:int = 0)
      {
         this._info = param1;
         this._showType = param2;
         super();
      }
      
      protected function initLoader() : void
      {
         if(!ClassUtils.uiSourceDomain.hasDefinition("wing_" + this.getshowTypeString() + "_" + this.info.TemplateID))
         {
            this._loader = LoaderManager.Instance.creatLoader(this.getUrl(),BaseLoader.MODULE_LOADER);
            this._loader.addEventListener(LoaderEvent.COMPLETE,this.__sourceComplete);
            LoaderManager.Instance.startLoad(this._loader);
         }
         else
         {
            this.__sourceComplete();
         }
      }
      
      protected function __sourceComplete(param1:LoaderEvent = null) : void
      {
         var _loc2_:Object = null;
         if(this.info == null)
         {
            return;
         }
         if(this._loader)
         {
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__sourceComplete);
         }
         if(param1 != null && !param1.loader.isSuccess)
         {
            this._wing = null;
         }
         else
         {
            _loc2_ = ClassUtils.uiSourceDomain.getDefinition("wing_" + this.getshowTypeString() + "_" + this.info.TemplateID) as Class;
            this._wing = new _loc2_();
         }
         this._isComplete = true;
         if(this._callBack != null)
         {
            this._callBack(this);
         }
      }
      
      public function setColor(param1:*) : Boolean
      {
         return false;
      }
      
      public function get info() : ItemTemplateInfo
      {
         return this._info;
      }
      
      public function set info(param1:ItemTemplateInfo) : void
      {
         this._info = param1;
      }
      
      public function getContent() : DisplayObject
      {
         return this._wing;
      }
      
      public function dispose() : void
      {
         if(this._loader)
         {
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__sourceComplete);
            this._loader = null;
         }
         this._wing = null;
         this._callBack = null;
         this._info = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function load(param1:Function) : void
      {
         this._callBack = param1;
         this.initLoader();
      }
      
      private function loadLayerComplete() : void
      {
      }
      
      public function set currentEdit(param1:int) : void
      {
      }
      
      public function get currentEdit() : int
      {
         return 0;
      }
      
      override public function get width() : Number
      {
         return 0;
      }
      
      override public function get height() : Number
      {
         return 0;
      }
      
      protected function getUrl() : String
      {
         return PathManager.soloveWingPath(this.info.Pic);
      }
      
      public function getshowTypeString() : String
      {
         if(this._showType == 0)
         {
            return "show";
         }
         return "game";
      }
      
      public function get isComplete() : Boolean
      {
         return this._isComplete;
      }
   }
}
