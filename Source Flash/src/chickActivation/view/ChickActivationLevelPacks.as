package chickActivation.view
{
   import chickActivation.ChickActivationManager;
   import chickActivation.event.ChickActivationEvent;
   import chickActivation.model.ChickActivationModel;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import ddt.view.tips.GoodTipInfo;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class ChickActivationLevelPacks extends Sprite implements Disposeable
   {
       
      
      public var packsLevelArr:Array;
      
      private var _arrData:Array;
      
      private var _progressLine1:Bitmap;
      
      private var _progressLine2:Bitmap;
      
      private var _drawProgress1Data:BitmapData;
      
      private var _drawProgress2Data:BitmapData;
      
      public function ChickActivationLevelPacks()
      {
         this.packsLevelArr = [{"level":5},{"level":10},{"level":25},{"level":30},{"level":40},{"level":45},{"level":48},{"level":50},{"level":55},{"level":60}];
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc2_:int = 0;
         var _loc3_:LevelPacksComponent = null;
         var _loc4_:GoodTipInfo = null;
         var _loc5_:Bitmap = null;
         var _loc6_:MovieClip = null;
         var _loc7_:InventoryItemInfo = null;
         this._progressLine1 = ComponentFactory.Instance.creatBitmap("assets.chickActivation.levelPacksProgressBg");
         PositionUtils.setPos(this._progressLine1,"chickActivation.progressLinePos1");
         addChild(this._progressLine1);
         this._progressLine2 = ComponentFactory.Instance.creatBitmap("assets.chickActivation.levelPacksProgressBg");
         PositionUtils.setPos(this._progressLine2,"chickActivation.progressLinePos2");
         addChild(this._progressLine2);
         this._drawProgress1Data = ComponentFactory.Instance.creatBitmapData("assets.chickActivation.levelPacksProgress1");
         this._drawProgress2Data = ComponentFactory.Instance.creatBitmapData("assets.chickActivation.levelPacksProgress2");
         var _loc1_:Array = ChickActivationManager.instance.model.itemInfoList[12];
         _loc2_ = 0;
         while(_loc2_ < this.packsLevelArr.length)
         {
            _loc3_ = new LevelPacksComponent();
            _loc4_ = new GoodTipInfo();
            if(_loc1_)
            {
               _loc7_ = ChickActivationManager.instance.model.getInventoryItemInfo(_loc1_[_loc2_]);
               _loc4_.itemInfo = _loc7_;
            }
            _loc3_.tipData = _loc4_;
            _loc5_ = ComponentFactory.Instance.creatBitmap("assets.chickActivation.packsLevel_" + this.packsLevelArr[_loc2_].level);
            PositionUtils.setPos(_loc5_,"chickActivation.packsLevelBitmapPos");
            _loc6_ = ClassUtils.CreatInstance("assets.chickActivation.packsMovie");
            _loc6_.gotoAndStop(1);
            PositionUtils.setPos(_loc6_,"chickActivation.packsMoviePos");
            _loc6_.mouseChildren = false;
            _loc6_.mouseEnabled = false;
            _loc3_.levelIndex = _loc2_ + 1;
            _loc3_.addChild(_loc5_);
            _loc3_.addChild(_loc6_);
            _loc3_.x = _loc2_ % 5 * 116;
            _loc3_.y = int(_loc2_ / 5) * 80;
            addChild(_loc3_);
            this.packsLevelArr[_loc2_].movie = _loc6_;
            this.packsLevelArr[_loc2_].sp = _loc3_;
            _loc2_++;
         }
      }
      
      private function initEvent() : void
      {
         this.addEventListener(MouseEvent.CLICK,this.__levelItemsClickHandler);
      }
      
      private function __levelItemsClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:LevelPacksComponent = null;
         var _loc3_:int = 0;
         if(param1.target is LevelPacksComponent)
         {
            _loc2_ = LevelPacksComponent(param1.target);
            if(_loc2_.isGray)
            {
               _loc3_ = LevelPacksComponent(param1.target).levelIndex;
               dispatchEvent(new ChickActivationEvent(ChickActivationEvent.CLICK_LEVELPACKS,_loc3_));
            }
         }
      }
      
      public function update() : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:MovieClip = null;
         var _loc8_:Boolean = false;
         var _loc1_:ChickActivationModel = ChickActivationManager.instance.model;
         var _loc2_:int = _loc1_.getRemainingDay();
         if(_loc1_.isKeyOpened > 0 && _loc2_ > 0)
         {
            _loc3_ = -1;
            _loc4_ = PlayerManager.Instance.Self.Grade;
            _loc5_ = 0;
            while(_loc5_ < this.packsLevelArr.length)
            {
               if(this.packsLevelArr[_loc5_].level <= _loc4_)
               {
                  _loc3_ = _loc5_;
               }
               _loc5_++;
            }
            if(_loc3_ == -1)
            {
               return;
            }
            if(_loc3_ > 4)
            {
               this.updateProgressLine(this._progressLine1,4);
               this.updateProgressLine(this._progressLine2,_loc3_ - 5);
            }
            else
            {
               this.updateProgressLine(this._progressLine1,_loc3_);
            }
            _loc6_ = 0;
            while(_loc6_ <= _loc3_)
            {
               _loc7_ = MovieClip(this.packsLevelArr[_loc6_].movie);
               _loc8_ = ChickActivationManager.instance.model.getGainLevel(_loc6_ + 1);
               if(_loc8_)
               {
                  _loc7_.gotoAndStop(1);
                  LevelPacksComponent(this.packsLevelArr[_loc6_].sp).buttonGrayFilters(_loc8_);
               }
               else
               {
                  _loc7_.gotoAndStop(2);
                  LevelPacksComponent(this.packsLevelArr[_loc6_].sp).buttonGrayFilters(_loc8_);
               }
               _loc6_++;
            }
         }
      }
      
      private function updateProgressLine(param1:Bitmap, param2:int) : void
      {
         if(param2 < 0)
         {
            return;
         }
         var _loc3_:Number = 116;
         var _loc4_:int = 0;
         while(_loc4_ <= param2)
         {
            param1.bitmapData.copyPixels(this._drawProgress1Data,this._drawProgress1Data.rect,new Point(_loc3_ * _loc4_,0),null,null,true);
            if(_loc4_ != 0)
            {
               param1.bitmapData.copyPixels(this._drawProgress2Data,this._drawProgress2Data.rect,new Point(_loc3_ * (_loc4_ - 1) + this._drawProgress1Data.width - 7,2),null,null,true);
            }
            _loc4_++;
         }
      }
      
      private function removeEvent() : void
      {
         this.removeEventListener(MouseEvent.CLICK,this.__levelItemsClickHandler);
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         this.removeEvent();
         if(this.packsLevelArr)
         {
            _loc1_ = 0;
            while(_loc1_ < this.packsLevelArr.length)
            {
               if(this.packsLevelArr[_loc1_].sp)
               {
                  ObjectUtils.disposeAllChildren(this.packsLevelArr[_loc1_].sp);
                  ObjectUtils.disposeObject(this.packsLevelArr[_loc1_].sp);
                  this.packsLevelArr[_loc1_].sp = null;
               }
               _loc1_++;
            }
            this.packsLevelArr = null;
         }
         ObjectUtils.disposeObject(this._progressLine1);
         this._progressLine1 = null;
         ObjectUtils.disposeObject(this._progressLine2);
         this._progressLine2 = null;
         ObjectUtils.disposeObject(this._drawProgress1Data);
         this._drawProgress1Data = null;
         ObjectUtils.disposeObject(this._drawProgress2Data);
         this._drawProgress2Data = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
