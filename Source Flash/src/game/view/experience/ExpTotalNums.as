package game.view.experience
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class ExpTotalNums extends Sprite implements Disposeable
   {
      
      public static const EXPERIENCE:uint = 0;
      
      public static const EXPLOIT:uint = 1;
       
      
      public var maxValue:int;
      
      private var _value:int;
      
      private var _type:int;
      
      private var _bg:MovieClip;
      
      private var _operator:Bitmap;
      
      private var _bitmaps:Vector.<Bitmap>;
      
      private var _bitmapDatas:Vector.<BitmapData>;
      
      public function ExpTotalNums(param1:int)
      {
         super();
         this._type = param1;
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:String = null;
         this._operator = new Bitmap();
         this._bitmaps = new Vector.<Bitmap>(5);
         this._bitmapDatas = new Vector.<BitmapData>();
         if(this._type == EXPERIENCE)
         {
            _loc1_ = "asset.experience.TotalExpNum_";
            this._bg = ComponentFactory.Instance.creat("asset.experience.TotalExpTxtLight");
         }
         else
         {
            _loc1_ = "asset.experience.TotalExploitNum_";
            this._bg = ComponentFactory.Instance.creat("asset.experience.TotalExploitTxtLight");
         }
         PositionUtils.setPos(this._bg,"experience.TotalTextLightPos");
         addChildAt(this._bg,0);
         var _loc2_:int = 0;
         while(_loc2_ < 10)
         {
            this._bitmapDatas.push(ComponentFactory.Instance.creatBitmapData(_loc1_ + String(_loc2_)));
            _loc2_++;
         }
         this._bitmapDatas.push(ComponentFactory.Instance.creatBitmapData(_loc1_ + "+"));
         this._bitmapDatas.push(ComponentFactory.Instance.creatBitmapData(_loc1_ + "-"));
      }
      
      public function playLight() : void
      {
         this._bg.gotoAndPlay(2);
      }
      
      public function setValue(param1:int) : void
      {
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:int = 0;
         _loc3_ = 0;
         var _loc4_:Array = null;
         _loc5_ = 0;
         if(param1 > this.maxValue)
         {
            this._value = this.maxValue;
         }
         else
         {
            this._value = param1;
         }
         _loc2_ = 0;
         _loc3_ = 20;
         if(this._value >= 0)
         {
            this._operator.bitmapData = this._bitmapDatas[10];
         }
         else
         {
            this._operator.bitmapData = this._bitmapDatas[11];
         }
         addChild(this._operator);
         _loc2_ += _loc3_;
         this._value = Math.abs(this._value);
         _loc4_ = this._value.toString().split("");
         _loc5_ = 0;
         while(_loc5_ < _loc4_.length)
         {
            if(this._bitmaps[_loc5_] == null)
            {
               this._bitmaps[_loc5_] = new Bitmap();
            }
            this._bitmaps[_loc5_].bitmapData = this._bitmapDatas[int(_loc4_[_loc5_])];
            this._bitmaps[_loc5_].x = _loc2_;
            _loc2_ += _loc3_;
            addChild(this._bitmaps[_loc5_]);
            _loc5_++;
         }
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function dispose() : void
      {
         if(this._bg)
         {
            if(this._bg.parent)
            {
               this._bg.parent.removeChild(this._bg);
            }
            this._bg = null;
         }
         if(this._operator)
         {
            if(this._operator.parent)
            {
               this._operator.parent.removeChild(this._operator);
            }
            this._operator.bitmapData.dispose();
            this._operator = null;
         }
         this._bitmapDatas = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
