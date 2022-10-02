package chickActivation.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   
   public class ChickActivationCoinsView extends Sprite implements Disposeable
   {
      
      private static const MAX_NUM_WIDTH:int = 8;
      
      private static const WIDTH:int = 15;
       
      
      private var _num:Vector.<ScaleFrameImage>;
      
      private var len:int = 1;
      
      private var coinsNum:int;
      
      public function ChickActivationCoinsView()
      {
         super();
         this._num = new Vector.<ScaleFrameImage>();
         this.setupCount();
      }
      
      public function set count(param1:int) : void
      {
         if(this.coinsNum == param1)
         {
            return;
         }
         this.initCoinsStyle();
         this.coinsNum = param1;
         this.updateCount();
      }
      
      private function setupCount() : void
      {
         while(this.len > this._num.length)
         {
            this._num.unshift(this.createCoinsNum(10));
         }
         while(this.len < this._num.length)
         {
            ObjectUtils.disposeObject(this._num.shift());
         }
         var _loc1_:int = MAX_NUM_WIDTH - this.len;
         var _loc2_:int = _loc1_ / 2 * WIDTH;
         var _loc3_:int = 0;
         while(_loc3_ < this.len)
         {
            this._num[_loc3_].x = _loc2_;
            _loc2_ += WIDTH;
            _loc3_++;
         }
      }
      
      private function updateCount() : void
      {
         var _loc1_:int = this.coinsNum.toString().length;
         if(_loc1_ != this.len)
         {
            this.len = _loc1_;
            this.setupCount();
         }
         this.initCoinsStyle();
      }
      
      private function initCoinsStyle() : void
      {
         var _loc1_:Array = this.coinsNum.toString().split("");
         this.updateCoinsView(_loc1_);
      }
      
      private function updateCoinsView(param1:Array) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.len)
         {
            if(param1[_loc2_] == 0)
            {
               param1[_loc2_] = 10;
            }
            this._num[_loc2_].setFrame(param1[_loc2_]);
            _loc2_++;
         }
      }
      
      private function play() : void
      {
      }
      
      private function createCoinsNum(param1:int = 0) : ScaleFrameImage
      {
         var _loc2_:ScaleFrameImage = ComponentFactory.Instance.creatComponentByStylename("chickActivation.CoinsNum");
         _loc2_.setFrame(param1);
         addChild(_loc2_);
         return _loc2_;
      }
      
      public function dispose() : void
      {
         if(this._num)
         {
            while(this._num.length)
            {
               ObjectUtils.disposeObject(this._num.shift());
            }
            this._num = null;
         }
      }
   }
}
