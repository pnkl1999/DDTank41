package game.view.experience
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Quad;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class ExpCountingTxt extends Sprite implements Disposeable
   {
       
      
      protected var _text:*;
      
      protected var _value:Number;
      
      protected var _targetValue:Number;
      
      protected var _style:String;
      
      protected var _filters:Array;
      
      protected var _plus:String;
      
      public var maxValue:int = 2147483647;
      
      public function ExpCountingTxt(param1:String, param2:String)
      {
         super();
         this._style = param1;
         this._filters = param2.split(",");
         this.init();
      }
      
      public function get value() : Number
      {
         return this._value;
      }
      
      public function set value(param1:Number) : void
      {
         this._value = param1;
      }
      
      public function get targetValue() : Number
      {
         return this._targetValue;
      }
      
      protected function init() : void
      {
         this._text = ComponentFactory.Instance.creatComponentByStylename(this._style);
         this._value = 0;
         this._targetValue = 0;
         this._plus = "+";
         this._text.text = this._plus + String(this._value) + " ";
         var _loc1_:Array = [];
         var _loc2_:int = 0;
         while(_loc2_ < this._filters.length)
         {
            _loc1_.push(ComponentFactory.Instance.model.getSet(this._filters[_loc2_]));
            _loc2_++;
         }
         this._text.filters = _loc1_;
         addChild(this._text);
      }
      
      public function updateNum(param1:Number, param2:Boolean = true) : void
      {
         if(param2)
         {
            this._targetValue += param1;
         }
         else
         {
            this._targetValue = param1;
         }
         if(this._targetValue > this.maxValue)
         {
            this._targetValue = this.maxValue;
         }
         TweenLite.killTweensOf(this);
         TweenLite.to(this,0.5,{
            "value":this._targetValue,
            "ease":Quad.easeOut,
            "onUpdate":this.updateText,
            "onComplete":this.complete
         });
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      protected function updateText() : void
      {
         var _loc2_:String = null;
         if(!this._text)
         {
            return;
         }
         var _loc1_:String = this._text.text;
         if(this._value < 0)
         {
            _loc2_ = String(Math.round(this._value)) + " ";
         }
         else
         {
            _loc2_ = this._plus + String(Math.round(this._value)) + " ";
         }
         if(_loc2_.indexOf("+") && _loc2_.indexOf("-"))
         {
            _loc2_ = _loc2_.replace("-");
         }
         if(_loc1_ != "+0 " && _loc2_ != _loc1_)
         {
            SoundManager.instance.play("143");
         }
         this._text.text = _loc2_;
      }
      
      public function complete(param1:Event = null) : void
      {
         this._value = this._targetValue;
         this.updateText();
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._text);
         this._text = null;
         this._filters = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
