package game.view.effects
{
   import com.pickgliss.ui.ComponentFactory;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import game.GameManager;
   
   public class ShootPercentView extends Sprite
   {
       
      
      private var _type:int;
      
      private var _isAdd:Boolean;
      
      private var _picBmp:Bitmap;
      
      private var add:Boolean = true;
      
      private var tmp:int = 0;
      
      public function ShootPercentView(param1:int, param2:int = 1, param3:Boolean = false)
      {
         super();
         this._type = param2;
         this._isAdd = param3;
         this._picBmp = this.getPercent(param1);
         this.addEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
         if(this._picBmp != null)
         {
            addChild(this._picBmp);
         }
      }
      
      public function dispose() : void
      {
         if(this._picBmp)
         {
            removeEventListener(Event.ENTER_FRAME,this.__enterFrame);
            this._picBmp.bitmapData.dispose();
            removeChild(this._picBmp);
            this._picBmp = null;
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      private function __addToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
         if(this._picBmp == null)
         {
            return;
         }
         if(this._type == 1)
         {
            this._picBmp.x = -70;
            this._picBmp.y = -20;
         }
         else
         {
            this._picBmp.scaleY = 0.5;
            this._picBmp.scaleX = 0.5;
         }
         this._picBmp.alpha = 0;
         addEventListener(Event.ENTER_FRAME,this.__enterFrame);
      }
      
      private function __enterFrame(param1:Event) : void
      {
         if(this._type == 1)
         {
            this.doShowType1();
         }
         else
         {
            this.doShowType2();
         }
      }
      
      private function doShowType1() : void
      {
         if(this._picBmp.alpha > 0.95)
         {
            ++this.tmp;
            if(this.tmp == 20)
            {
               this.add = false;
               this._picBmp.alpha = 0.9;
            }
         }
         if(this._picBmp.alpha < 1)
         {
            if(this.add)
            {
               this._picBmp.y -= 8;
               this._picBmp.alpha += 0.22;
            }
            else
            {
               this._picBmp.y -= 6;
               this._picBmp.alpha -= 0.1;
            }
         }
         if(this._picBmp.alpha < 0.05)
         {
            this.dispose();
         }
      }
      
      private function doShowType2() : void
      {
         if(this._picBmp.alpha > 0.95)
         {
            ++this.tmp;
            if(this.tmp == 20)
            {
               this.add = false;
               this._picBmp.alpha = 0.9;
            }
         }
         if(this._picBmp.alpha < 1)
         {
            if(this.add)
            {
               this._picBmp.scaleX = this._picBmp.scaleY = this._picBmp.scaleY + 0.24;
               this._picBmp.alpha += 0.4;
            }
            else
            {
               this._picBmp.scaleX = this._picBmp.scaleY = this._picBmp.scaleY + 0.125;
               this._picBmp.alpha -= 0.15;
            }
            this._picBmp.x = -this._picBmp.width / 2 + 10;
            this._picBmp.y = -this._picBmp.height / 2;
         }
         if(this._picBmp.alpha < 0.05)
         {
            this.dispose();
         }
      }
      
      public function getPercent(param1:int) : Bitmap
      {
         var _loc3_:Array = null;
         var _loc9_:Bitmap = null;
         var _loc10_:Bitmap = null;
         _loc3_ = null;
         _loc9_ = null;
         _loc10_ = null;
         var _loc11_:Bitmap = null;
         if(param1 > 99999999)
         {
            return null;
         }
         var _loc2_:Sprite = new Sprite();
         _loc3_ = new Array();
         _loc3_ = [0,0,0,0];
         _loc2_.mouseEnabled = false;
         _loc2_.mouseChildren = false;
         if(this._type == 2)
         {
            if(!this._isAdd)
            {
               _loc9_ = ComponentFactory.Instance.creatBitmap("asset.game.redNumberBackgoundAsset") as Bitmap;
               _loc9_.x += 5;
               _loc9_.y = -10;
               _loc3_.push(_loc9_);
            }
         }
         var _loc4_:String = String(param1);
         var _loc5_:int = _loc4_.length;
         var _loc6_:int = 33 + (4 - _loc5_) * 10;
         if(this._isAdd)
         {
            _loc4_ = " " + _loc4_;
            _loc5_ += 1;
            _loc6_ -= 10;
            _loc10_ = ComponentFactory.Instance.creatBitmap("asset.game.addBloodIconAsset") as Bitmap;
            _loc10_.x = _loc6_;
            _loc10_.y = 20;
            _loc3_.push(_loc10_);
         }
         var _loc7_:int = !!this._isAdd ? int(int(1)) : int(int(0));
         while(_loc7_ < _loc5_)
         {
            if(this._isAdd)
            {
               _loc11_ = GameManager.Instance.numCreater.createGreenNum(int(_loc4_.charAt(_loc7_)));
            }
            else
            {
               _loc11_ = GameManager.Instance.numCreater.createRedNum(int(_loc4_.charAt(_loc7_)));
            }
            _loc11_.smoothing = true;
            _loc11_.x = _loc6_ + _loc7_ * 20;
            _loc11_.y = 20;
            _loc3_.push(_loc11_);
            _loc7_++;
         }
         _loc3_ = this.returnNum(_loc3_);
         var _loc8_:BitmapData = new BitmapData(_loc3_[2],_loc3_[3],true,0);
         this._picBmp = new Bitmap(_loc8_,"auto",true);
         _loc7_ = 4;
         while(_loc7_ < _loc3_.length)
         {
            _loc8_.copyPixels(_loc3_[_loc7_].bitmapData,new Rectangle(0,0,_loc3_[_loc7_].width,_loc3_[_loc7_].height),new Point(_loc3_[_loc7_].x - _loc3_[0],_loc3_[_loc7_].y - _loc3_[1]),null,null,true);
            _loc7_++;
         }
         this._picBmp.x = _loc3_[0];
         this._picBmp.y = _loc3_[1];
         _loc3_ = null;
         return this._picBmp;
      }
      
      private function returnNum(param1:Array) : Array
      {
         var _loc2_:int = 4;
         while(_loc2_ < param1.length)
         {
            param1[0] = param1[0] > param1[_loc2_].x ? param1[_loc2_].x : param1[0];
            param1[1] = param1[1] > param1[_loc2_].y ? param1[_loc2_].y : param1[1];
            param1[2] = param1[2] > param1[_loc2_].width + param1[_loc2_].x ? param1[2] : param1[_loc2_].width + param1[_loc2_].x;
            param1[3] = param1[3] > param1[_loc2_].height + param1[_loc2_].y ? param1[3] : param1[_loc2_].height + param1[_loc2_].y;
            _loc2_++;
         }
         param1[2] -= param1[0];
         param1[3] -= param1[1];
         return param1;
      }
   }
}
