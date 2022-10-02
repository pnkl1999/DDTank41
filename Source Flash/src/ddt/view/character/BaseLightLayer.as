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
   
   public class BaseLightLayer extends Sprite implements ILayer
   {
       
      
      private var _light:MovieClip;
      
      private var _type:int;
      
      private var _callBack:Function;
      
      private var _loader:ModuleLoader;
      
      private var _nimbus:int;
      
      private var _isComplete:Boolean;
      
      public function BaseLightLayer(param1:int, param2:int = 0)
      {
         super();
         this._nimbus = param1;
         this._type = param2;
      }
      
      public function load(param1:Function) : void
      {
         this._callBack = param1;
         this.initLoader();
      }
      
      protected function initLoader() : void
      {
         if(this.getId() == "00")
         {
            return;
         }
         if(!ClassUtils.uiSourceDomain.hasDefinition("game.crazyTank.view.light.CircleLightAsset_" + this.getId()))
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
      
      private function getId() : String
      {
         if(this._nimbus == 0)
         {
            return "00";
         }
         var _loc1_:String = this._nimbus.toString();
         _loc1_ = _loc1_.substr(_loc1_.length - 2,_loc1_.length);
         return Number(_loc1_).toString();
      }
      
      protected function __sourceComplete(param1:LoaderEvent = null) : void
      {
         var _loc2_:Object = null;
         if(this._loader)
         {
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__sourceComplete);
         }
         if(param1 != null && !param1.loader.isSuccess)
         {
            this._light = null;
         }
         else if(this.getId() != "00" && this.getId() != "0")
         {
            _loc2_ = ClassUtils.uiSourceDomain.getDefinition("game.crazyTank.view.light.CircleLightAsset_" + this.getId()) as Class;
            this._light = new _loc2_() as MovieClip;
         }
         this._isComplete = true;
         if(this._callBack != null && this._light != null)
         {
            this._callBack(this);
         }
      }
      
      protected function getUrl() : String
      {
         return PathManager.soloveCircleLightPath(this.getId());
      }
      
      public function getshowTypeString() : String
      {
         if(this._type == 0)
         {
            return "show";
         }
         return "game";
      }
      
      public function get info() : ItemTemplateInfo
      {
         return null;
      }
      
      public function set info(param1:ItemTemplateInfo) : void
      {
      }
      
      public function getContent() : DisplayObject
      {
         return this._light;
      }
      
      public function dispose() : void
      {
         if(this._light && this._light.parent)
         {
            this._light.parent.removeChild(this._light);
         }
         this._light = null;
         this._callBack = null;
         if(this._loader)
         {
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__sourceComplete);
         }
         this._loader = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      public function set currentEdit(param1:int) : void
      {
      }
      
      public function get currentEdit() : int
      {
         return 0;
      }
      
      public function setColor(param1:*) : Boolean
      {
         return false;
      }
      
      public function get isComplete() : Boolean
      {
         return this._isComplete;
      }
   }
}
