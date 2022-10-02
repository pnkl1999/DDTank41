package consortion.view.selfConsortia
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.BitmapLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.data.BadgeInfo;
   import ddt.manager.BadgeInfoManager;
   import ddt.manager.PathManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class Badge extends Sprite implements Disposeable, ITipedDisplay
   {
      
      public static const LARGE:String = "large";
      
      public static const NORMAL:String = "normal";
      
      public static const SMALL:String = "small";
      
      private static const LARGE_SIZE:int = 66;
      
      private static const NORMAL_SIZE:int = 48;
      
      private static const SMALL_SIZE:int = 28;
       
      
      private var _size:String = "large";
      
      private var _badgeID:int = -1;
      
      private var _buyDate:Date;
      
      private var _badge:Bitmap;
      
      private var _loader:BitmapLoader;
      
      private var _clickEnale:Boolean = false;
      
      private var _tipInfo:Object;
      
      private var _tipDirctions:String;
      
      private var _tipGapH:int;
      
      private var _tipGapV:int;
      
      private var _tipStyle:String = "consortion.view.selfConsortia.BadgeTip";
      
      private var _showTip:Boolean;
      
      public function Badge(param1:String = "small")
      {
         super();
         this._size = param1;
         graphics.beginFill(16777215,0);
         var _loc2_:int = 0;
         if(this._size == LARGE)
         {
            _loc2_ = LARGE_SIZE;
         }
         else if(this._size == NORMAL)
         {
            _loc2_ = NORMAL_SIZE;
         }
         else if(this._size == SMALL)
         {
            _loc2_ = SMALL_SIZE;
         }
         graphics.drawRect(0,0,_loc2_,_loc2_);
         graphics.endFill();
         this._tipGapV = 5;
         this._tipGapH = 5;
         this._tipDirctions = "7,6,5";
         if(this._size == SMALL)
         {
            this._tipStyle = "ddt.view.tips.OneLineTip";
         }
         else
         {
            this._tipStyle = "consortion.view.selfConsortia.BadgeTip";
         }
      }
      
      public function get showTip() : Boolean
      {
         return this._showTip;
      }
      
      public function set showTip(param1:Boolean) : void
      {
         this._showTip = param1;
         if(this._showTip)
         {
            ShowTipManager.Instance.addTip(this);
         }
         else
         {
            ShowTipManager.Instance.removeTip(this);
         }
      }
      
      public function get clickEnale() : Boolean
      {
         return this._clickEnale;
      }
      
      public function set clickEnale(param1:Boolean) : void
      {
         if(param1 == this._clickEnale)
         {
            return;
         }
         this._clickEnale = param1;
         if(this._clickEnale)
         {
            addEventListener(MouseEvent.CLICK,this.onClick);
         }
         else
         {
            removeEventListener(MouseEvent.CLICK,this.onClick);
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc2_:BadgeShopFrame = ComponentFactory.Instance.creatComponentByStylename("consortion.badgeShopFrame");
         LayerManager.Instance.addToLayer(_loc2_,LayerManager.GAME_DYNAMIC_LAYER,true);
      }
      
      public function get buyDate() : Date
      {
         return this._buyDate;
      }
      
      public function set buyDate(param1:Date) : void
      {
         this._buyDate = param1;
      }
      
      public function get badgeID() : int
      {
         return this._badgeID;
      }
      
      public function set badgeID(param1:int) : void
      {
         if(param1 == this._badgeID)
         {
            return;
         }
         this._badgeID = param1;
         this._tipInfo = {};
         var _loc2_:BadgeInfo = BadgeInfoManager.instance.getBadgeInfoByID(this._badgeID);
         if(_loc2_)
         {
            this._tipInfo.name = _loc2_.BadgeName;
            this._tipInfo.LimitLevel = _loc2_.LimitLevel;
            this._tipInfo.ValidDate = _loc2_.ValidDate;
            if(this._buyDate)
            {
               this._tipInfo.buyDate = this._buyDate;
            }
         }
         this.updateView();
      }
      
      private function updateView() : void
      {
         this.removeBadge();
         this._loader = LoaderManager.Instance.creatLoader(PathManager.solveBadgePath(this._badgeID),BaseLoader.BITMAP_LOADER);
         this._loader.addEventListener(LoaderEvent.COMPLETE,this.onComplete);
         this._loader.addEventListener(LoaderEvent.LOAD_ERROR,this.onError);
         LoaderManager.Instance.startLoad(this._loader);
      }
      
      private function removeBadge() : void
      {
         if(this._badge)
         {
            if(this._badge.parent)
            {
               this._badge.parent.removeChild(this._badge);
            }
            this._badge.bitmapData.dispose();
            this._badge = null;
         }
      }
      
      private function onComplete(param1:LoaderEvent) : void
      {
         this._loader.removeEventListener(LoaderEvent.COMPLETE,this.onComplete);
         this._loader.removeEventListener(LoaderEvent.LOAD_ERROR,this.onError);
         if(this._loader.isSuccess)
         {
            this._badge = this._loader.content as Bitmap;
            if(this._size == LARGE)
            {
               this._badge.width = this._badge.height = LARGE_SIZE;
            }
            else if(this._size == NORMAL)
            {
               this._badge.width = this._badge.height = NORMAL_SIZE;
            }
            else
            {
               this._badge.width = this._badge.height = SMALL_SIZE;
            }
            addChild(this._badge);
         }
      }
      
      private function onError(param1:LoaderEvent) : void
      {
         this._loader.removeEventListener(LoaderEvent.COMPLETE,this.onComplete);
         this._loader.removeEventListener(LoaderEvent.LOAD_ERROR,this.onError);
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function get tipData() : Object
      {
         return this._tipInfo;
      }
      
      public function set tipData(param1:Object) : void
      {
         this._tipInfo = param1;
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirctions;
      }
      
      public function set tipDirctions(param1:String) : void
      {
         this._tipDirctions = param1;
      }
      
      public function get tipGapH() : int
      {
         return this._tipGapH;
      }
      
      public function set tipGapH(param1:int) : void
      {
         this._tipGapH = param1;
      }
      
      public function get tipGapV() : int
      {
         return this._tipGapV;
      }
      
      public function set tipGapV(param1:int) : void
      {
         this._tipGapV = param1;
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function set tipStyle(param1:String) : void
      {
         this._tipStyle = param1;
      }
      
      public function dispose() : void
      {
         ShowTipManager.Instance.removeTip(this);
         ObjectUtils.disposeObject(this._badge);
         this._badge = null;
         if(this._loader)
         {
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.onComplete);
            this._loader.removeEventListener(LoaderEvent.LOAD_ERROR,this.onError);
         }
         this._loader = null;
         this._tipInfo = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
