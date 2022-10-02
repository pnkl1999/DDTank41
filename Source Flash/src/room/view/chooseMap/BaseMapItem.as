package room.view.chooseMap
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.map.DungeonInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MapManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class BaseMapItem extends Sprite implements Disposeable
   {
       
      
      protected var _mapId:int = -1;
      
      protected var _selected:Boolean;
      
      protected var _bg:Bitmap;
      
      protected var _mapIconContaioner:Sprite;
      
      protected var _selectedBg:Bitmap;
      
      protected var _loader:DisplayLoader;
      
      public function BaseMapItem()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      override public function get height() : Number
      {
         return Math.max(this._bg.height,this._selectedBg.height);
      }
      
      override public function get width() : Number
      {
         return Math.max(this._bg.width,this._selectedBg.width);
      }
      
      protected function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.room.mapItemBgAsset");
         addChild(this._bg);
         this._mapIconContaioner = new Sprite();
         addChild(this._mapIconContaioner);
         this._selectedBg = ComponentFactory.Instance.creatBitmap("asset.room.mapItemSelectedAsset");
         addChild(this._selectedBg);
         this._selectedBg.visible = false;
      }
      
      protected function initEvents() : void
      {
         addEventListener(MouseEvent.CLICK,this.__onClick);
      }
      
      protected function removeEvents() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__onClick);
      }
      
      protected function updateMapIcon() : void
      {
         if(this._loader != null)
         {
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__onComplete);
         }
         this._loader = LoaderManager.Instance.creatLoader(this.solvePath(),BaseLoader.BITMAP_LOADER);
         this._loader.addEventListener(LoaderEvent.COMPLETE,this.__onComplete);
         LoaderManager.Instance.startLoad(this._loader);
      }
      
      protected function solvePath() : String
      {
         return PathManager.SITE_MAIN + "image/map/" + this._mapId.toString() + "/samll_map_s.jpg";
      }
      
      protected function __onComplete(param1:LoaderEvent) : void
      {
         var _loc2_:Bitmap = null;
         ObjectUtils.disposeAllChildren(this._mapIconContaioner);
         this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__onComplete);
         this._loader = null;
         if(BaseLoader(param1.loader).isSuccess)
         {
            _loc2_ = Bitmap(param1.loader.content);
            _loc2_.width = this._bg.width;
            _loc2_.height = this._bg.height;
            this._mapIconContaioner.addChild(_loc2_);
         }
      }
      
      protected function updateSelectState() : void
      {
         this._selectedBg.visible = this._selected;
      }
      
      private function __onClick(param1:MouseEvent) : void
      {
         var _loc2_:DungeonInfo = null;
         if(this._mapId > -1)
         {
            SoundManager.instance.play("045");
            _loc2_ = MapManager.getDungeonInfo(this._mapId) as DungeonInfo;
            if(_loc2_ && _loc2_.LevelLimits > PlayerManager.Instance.Self.Grade)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomMapSetPanelDuplicate.clew",_loc2_.LevelLimits));
               return;
            }
            this.selected = true;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         removeChild(this._bg);
         this._bg.bitmapData.dispose();
         this._bg = null;
         ObjectUtils.disposeAllChildren(this._mapIconContaioner);
         removeChild(this._mapIconContaioner);
         this._mapIconContaioner = null;
         if(this._selectedBg)
         {
            if(this._selectedBg.parent != null)
            {
               this._selectedBg.parent.removeChild(this._selectedBg);
            }
            this._selectedBg.bitmapData.dispose();
         }
         this._selectedBg = null;
         if(this._loader != null)
         {
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__onComplete);
         }
         this._loader = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this._selected == param1)
         {
            return;
         }
         this._selected = param1;
         this.updateSelectState();
         if(this._selected)
         {
            dispatchEvent(new Event(Event.SELECT));
         }
      }
      
      public function get mapId() : int
      {
         return this._mapId;
      }
      
      public function set mapId(param1:int) : void
      {
         this._mapId = param1;
         this.updateMapIcon();
         buttonMode = this.mapId != 10000;
      }
   }
}
