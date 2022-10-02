package room.view.smallMapInfoPanel
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.MapManager;
   import ddt.manager.PathManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class MissionRoomSmallMapInfoPanel extends BaseSmallMapInfoPanel
   {
       
      
      protected var _modeTitle:Bitmap;
      
      protected var _mode:Bitmap;
      
      protected var _diffTitle:Bitmap;
      
      protected var _diff:ScaleFrameImage;
      
      protected var _levelRangeTitle:Bitmap;
      
      protected var _levelRange:FilterFrameText;
      
      protected var _titleLoader:DisplayLoader;
      
      protected var _titleContainer:Sprite;
      
      public function MissionRoomSmallMapInfoPanel()
      {
         super();
      }
      
      override protected function initView() : void
      {
         super.initView();
         this._diffTitle = ComponentFactory.Instance.creatBitmap("asset.room.levelAsset");
         addChild(this._diffTitle);
         this._modeTitle = ComponentFactory.Instance.creatBitmap("asset.room.modeAsset");
         addChild(this._modeTitle);
         this._levelRangeTitle = ComponentFactory.Instance.creatBitmap("asset.room.levelRangeAsset");
         addChild(this._levelRangeTitle);
         this._mode = ComponentFactory.Instance.creatBitmap("asset.room.dungeonTxtAsset");
         addChild(this._mode);
         this._diff = ComponentFactory.Instance.creatComponentByStylename("asset.room.diffAsset");
         addChild(this._diff);
         this._levelRange = ComponentFactory.Instance.creatComponentByStylename("assest.room.levelRangeTxt");
         addChild(this._levelRange);
         this._titleContainer = ComponentFactory.Instance.creatCustomObject("asset.room.smallMapTitleContainer");
         addChild(this._titleContainer);
      }
      
      override protected function updateView() : void
      {
         super.updateView();
         this._levelRangeTitle.visible = this._modeTitle.visible = this._diffTitle.visible = this._levelRange.visible = this._mode.visible = this._diff.visible = _info && _info.mapId != 0 && _info.mapId != 10000;
         this.solveLeveRange();
         this._diff.setFrame(_info.hardLevel + 1);
         if(this._titleLoader)
         {
            this._titleLoader.removeEventListener(LoaderEvent.COMPLETE,this.__titleComplete);
         }
         if(_info && _info.mapId > 0 && _info.mapId != 10000)
         {
            this._titleLoader = LoaderManager.Instance.creatLoader(this.solveTitlePath(),BaseLoader.BITMAP_LOADER);
            this._titleLoader.addEventListener(LoaderEvent.COMPLETE,this.__titleComplete);
            LoaderManager.Instance.startLoad(this._titleLoader);
         }
         else
         {
            ObjectUtils.disposeAllChildren(this._titleContainer);
         }
      }
      
      protected function __titleComplete(param1:LoaderEvent) : void
      {
         this._titleLoader.removeEventListener(LoaderEvent.COMPLETE,this.__titleComplete);
         ObjectUtils.disposeAllChildren(this._titleContainer);
         if(this._titleLoader.isSuccess)
         {
            this._titleContainer.addChild(this._titleLoader.content as Bitmap);
         }
      }
      
      protected function solveTitlePath() : String
      {
         return PathManager.SITE_MAIN + "image/map/" + _info.mapId.toString() + "/icon.png";
      }
      
      private function solveLeveRange() : void
      {
         var _loc2_:Array = null;
         if(_info == null || _info.mapId == 0 || _info.mapId == 10000)
         {
            return;
         }
         var _loc1_:String = MapManager.getDungeonInfo(_info.mapId).AdviceTips;
         if(_loc1_)
         {
            _loc2_ = _loc1_.split("|");
            this._levelRange.text = "";
            if(_info.hardLevel >= _loc2_.length)
            {
               return;
            }
            this._levelRange.text = _loc2_[_info.hardLevel];
         }
      }
      
      override public function dispose() : void
      {
         removeChild(this._modeTitle);
         this._modeTitle.bitmapData.dispose();
         this._modeTitle = null;
         if(this._mode)
         {
            if(this._mode.parent)
            {
               this._mode.parent.removeChild(this._mode);
            }
            this._mode.bitmapData.dispose();
            this._mode = null;
         }
         removeChild(this._diffTitle);
         this._diffTitle.bitmapData.dispose();
         this._diffTitle = null;
         this._diff.dispose();
         this._diff = null;
         removeChild(this._levelRangeTitle);
         this._levelRangeTitle.bitmapData.dispose();
         this._levelRangeTitle = null;
         this._levelRange.dispose();
         this._levelRange = null;
         ObjectUtils.disposeAllChildren(this._titleContainer);
         removeChild(this._titleContainer);
         this._titleContainer = null;
         if(this._titleLoader != null)
         {
            this._titleLoader.removeEventListener(LoaderEvent.COMPLETE,this.__titleComplete);
         }
         this._titleLoader = null;
         super.dispose();
      }
   }
}
