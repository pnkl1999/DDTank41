package roomLoading.view
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.manager.PathManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import game.GameManager;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class RoomLoadingBattleFieldItem extends Sprite implements Disposeable
   {
       
      
      private var _mapId:int;
      
      private var _bg:Bitmap;
      
      private var _mapLoader:DisplayLoader;
      
      private var _fieldBg:Bitmap;
      
      private var _fieldNameLoader:DisplayLoader;
      
      private var _map:Bitmap;
      
      private var _fieldName:Bitmap;
      
      public function RoomLoadingBattleFieldItem(param1:int = -1)
      {
         var mapId:int = param1;
         super();
         if(RoomManager.Instance.current.mapId > 0)
         {
            mapId = RoomManager.Instance.current.mapId;
         }
         this._mapId = mapId;
         try
         {
            this.init();
            return;
         }
         catch(error:Error)
         {
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__onScaleBitmapLoaded);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.CORE_SCALE_BITMAP);
            return;
         }
      }
      
      private function __onScaleBitmapLoaded(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.CORE_SCALE_BITMAP)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__onScaleBitmapLoaded);
            this.init();
         }
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.roomLoading.BattleFieldBg");
         this._fieldBg = ComponentFactory.Instance.creatBitmap("asset.roomLoading.FieldNameBg");
         addChild(this._bg);
         this._mapLoader = LoaderManager.Instance.creatLoader(this.solveMapPath(1),BaseLoader.BITMAP_LOADER);
         this._mapLoader.addEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
         LoaderManager.Instance.startLoad(this._mapLoader);
         this._fieldNameLoader = LoaderManager.Instance.creatLoader(this.solveMapPath(2),BaseLoader.BITMAP_LOADER);
         this._fieldNameLoader.addEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
         LoaderManager.Instance.startLoad(this._fieldNameLoader);
      }
      
      private function __onLoadComplete(param1:LoaderEvent) : void
      {
         if(param1.currentTarget.isSuccess)
         {
            if(param1.currentTarget == this._mapLoader)
            {
               this._map = PositionUtils.setPos(Bitmap(this._mapLoader.content),"roomLoading.BattleFieldItemMapPos");
               this._map = Bitmap(this._mapLoader.content);
            }
            else if(param1.currentTarget == this._fieldNameLoader)
            {
               this._fieldName = PositionUtils.setPos(Bitmap(this._fieldNameLoader.content),"roomLoading.BattleFieldItemNamePos");
               this._fieldName = Bitmap(this._fieldNameLoader.content);
            }
         }
         if(this._map)
         {
            addChild(this._map);
         }
         addChild(this._fieldBg);
         if(this._fieldName)
         {
            addChild(this._fieldName);
         }
      }
      
      private function solveMapPath(param1:int) : String
      {
         var _loc2_:String = "samll_map";
         if(param1 == 2)
         {
            _loc2_ = "icon";
         }
         var _loc3_:String = PathManager.SITE_MAIN + "image/map/";
         if(GameManager.Instance.Current && GameManager.Instance.Current.gameMode == 8)
         {
            return _loc3_ + ("1133/" + _loc2_ + ".png");
         }
         if(RoomManager.Instance.current.type == RoomInfo.LANBYRINTH_ROOM && param1 != 2)
         {
            return _loc3_ + "214/samll_map.png";
         }
         return _loc3_ + (this._mapId.toString() + "/" + _loc2_ + ".png");
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._mapLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
         this._fieldNameLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
