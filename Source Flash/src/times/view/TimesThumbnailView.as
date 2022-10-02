package times.view
{
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import times.TimesController;
   import times.data.TimesPicInfo;
   
   public class TimesThumbnailView extends Sprite implements Disposeable
   {
       
      
      private var _controller:TimesController;
      
      private var _pointArr:Vector.<TimesThumbnailPoint>;
      
      private var _spacing:int;
      
      private var _pointGroup:SelectedButtonGroup;
      
      private var _pointIdx:int;
      
      public function TimesThumbnailView(param1:TimesController)
      {
         super();
         this._controller = param1;
         this.init();
      }
      
      private function init() : void
      {
         var _loc9_:TimesThumbnailPoint = null;
         var _loc3_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:TimesPicInfo = null;
         _loc9_ = null;
         this._pointGroup = new SelectedButtonGroup();
         this._pointArr = new Vector.<TimesThumbnailPoint>();
         var _loc1_:Vector.<int> = new Vector.<int>();
         var _loc2_:int = 0;
         var _loc4_:Array = this._controller.model.contentInfos;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc1_.push(_loc4_[_loc5_].length);
            _loc3_ += _loc1_[_loc5_];
            _loc5_++;
         }
         if(_loc3_ != 0)
         {
            this._spacing = 360 / (_loc3_ - 1);
         }
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_.length)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc1_[_loc6_])
            {
               _loc8_ = new TimesPicInfo();
               _loc8_.targetCategory = _loc6_;
               _loc8_.targetPage = _loc7_;
               _loc9_ = new TimesThumbnailPoint(_loc8_);
               _loc9_.tipStyle = "times.view.TimesThumbnailPointTip";
               _loc9_.tipDirctions = "0";
               _loc9_.tipGapV = 10;
               _loc9_.tipData = {
                  "isRevertTip":Boolean(_loc2_ > _loc3_ / 2),
                  "category":_loc6_,
                  "page":_loc7_
               };
               _loc9_.x = _loc2_++ * this._spacing;
               this._pointGroup.addSelectItem(_loc9_);
               addChild(_loc9_);
               this._pointArr.push(_loc9_);
               _loc7_++;
            }
            _loc6_++;
         }
         this._pointGroup.selectIndex = 0;
      }
      
      public function set pointIdx(param1:int) : void
      {
         if(this._pointIdx == param1)
         {
            return;
         }
         this._pointArr[this._pointIdx].pointPlay("rollOut");
         this._pointIdx = param1;
         this._pointArr[this._pointIdx].pointStop("selected");
         this._pointGroup.selectIndex = this._pointIdx;
      }
      
      public function dispose() : void
      {
         this._controller = null;
         ObjectUtils.disposeObject(this._pointGroup);
         this._pointGroup = null;
         this._pointArr = null;
         this._controller = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
