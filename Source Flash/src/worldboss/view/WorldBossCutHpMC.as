package worldboss.view
{
   import com.pickgliss.ui.ComponentFactory;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.setTimeout;
   
   public class WorldBossCutHpMC extends Sprite
   {
      
      public static const _space:int = 19;
       
      
      private var _num:Number;
      
      private var _type:int;
      
      private var _numBitmapArr:Array;
      
      public function WorldBossCutHpMC(param1:Number)
      {
         super();
         this._num = Math.abs(param1);
         this.init();
      }
      
      private function init() : void
      {
         var _loc4_:Bitmap = null;
         this._numBitmapArr = new Array();
         var _loc1_:String = this._num.toString();
         var _loc2_:Bitmap = ComponentFactory.Instance.creatBitmap("worldboss.cutHP.valuNum10");
         this._numBitmapArr.push(_loc2_);
         _loc2_.alpha = 0;
         _loc2_.scaleX = 0.5;
         addChild(_loc2_);
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_.length)
         {
            _loc4_ = ComponentFactory.Instance.creatBitmap("worldboss.cutHP.valuNum" + _loc1_.charAt(_loc3_));
            _loc4_.x = _space * (_loc3_ + 1);
            _loc4_.alpha = 0;
            _loc4_.scaleX = 0.5;
            this._numBitmapArr.push(_loc4_);
            addChild(_loc4_);
            _loc3_++;
         }
         addEventListener(Event.ENTER_FRAME,this.actionOne);
      }
      
      private function actionOne(param1:Event) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._numBitmapArr.length)
         {
            if(this._numBitmapArr[_loc2_].alpha >= 1)
            {
               removeEventListener(Event.ENTER_FRAME,this.actionOne);
               setTimeout(this.actionTwo,500);
               return;
            }
            this._numBitmapArr[_loc2_].alpha += 0.2;
            this._numBitmapArr[_loc2_].scaleX += 0.1;
            this._numBitmapArr[_loc2_].x += 2;
            this._numBitmapArr[_loc2_].y -= 7;
            _loc2_++;
         }
      }
      
      private function actionTwo() : void
      {
         addEventListener(Event.ENTER_FRAME,this.actionTwoStart);
      }
      
      private function actionTwoStart(param1:Event) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._numBitmapArr.length)
         {
            if(this._numBitmapArr[_loc2_].alpha <= 0)
            {
               this.dispose();
               return;
            }
            this._numBitmapArr[_loc2_].alpha -= 0.2;
            this._numBitmapArr[_loc2_].y -= 7;
            _loc2_++;
         }
      }
      
      private function dispose() : void
      {
         var _loc1_:int = 0;
         removeEventListener(Event.ENTER_FRAME,this.actionTwoStart);
         if(this._numBitmapArr)
         {
            _loc1_ = 0;
            while(_loc1_ < this._numBitmapArr.length)
            {
               removeChild(this._numBitmapArr[_loc1_]);
               this._numBitmapArr[_loc1_] = null;
               this._numBitmapArr.shift();
            }
            this._numBitmapArr = null;
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
