package game.view
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import game.view.effects.BaseMirariEffectIcon;
   import road7th.data.DictionaryData;
   import road7th.data.DictionaryEvent;
   
   [Event(name="change",type="flash.events.Event")]
   public class EffectIconContainer extends Sprite
   {
       
      
      private var _data:DictionaryData;
      
      private var _spList:Array;
      
      private var _list:Vector.<BaseMirariEffectIcon>;
      
      public function EffectIconContainer()
      {
         this._list = new Vector.<BaseMirariEffectIcon>();
         super();
         mouseEnabled = false;
         mouseChildren = false;
         this.initialize();
         this.initEvent();
      }
      
      private function initialize() : void
      {
         if(this._spList || this._data)
         {
            this.release();
         }
         this._data = new DictionaryData();
         this._spList = [];
      }
      
      private function release() : void
      {
         this.clearIcons();
         if(this._data)
         {
            this.removeEvent();
            this._data.clear();
         }
         this._data = null;
      }
      
      private function clearIcons() : void
      {
         var _loc1_:DisplayObject = null;
         for each(_loc1_ in this._spList)
         {
            removeChild(_loc1_);
         }
         this._spList = [];
      }
      
      private function drawIcons(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:DisplayObject = null;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = this._data.list[_loc2_];
            _loc3_.x = (_loc2_ & 3) * 21;
            _loc3_.y = (_loc2_ >> 2) * 21;
            this._spList.push(_loc3_);
            addChild(_loc3_);
            _loc2_++;
         }
      }
      
      private function initEvent() : void
      {
         this._data.addEventListener(DictionaryEvent.ADD,this.__changeEffectHandler);
         this._data.addEventListener(DictionaryEvent.REMOVE,this.__changeEffectHandler);
      }
      
      private function removeEvent() : void
      {
         if(this._data)
         {
            this._data.removeEventListener(DictionaryEvent.ADD,this.__changeEffectHandler);
            this._data.removeEventListener(DictionaryEvent.REMOVE,this.__changeEffectHandler);
         }
      }
      
      private function __changeEffectHandler(param1:DictionaryEvent) : void
      {
         var _loc2_:Sprite = param1.data as Sprite;
         this._updateList();
      }
      
      private function _updateList() : void
      {
         this.clearIcons();
         this.drawIcons(this._data.list);
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      override public function get width() : Number
      {
         return this._spList.length % 5 * 21;
      }
      
      override public function get height() : Number
      {
         return (Math.floor(this._spList.length / 5) + 1) * 21;
      }
      
      public function handleEffect(param1:int, param2:DisplayObject) : void
      {
         if(param2)
         {
            this._data.add(param1,param2);
         }
      }
      
      public function removeEffect(param1:int) : void
      {
         this._data.remove(param1);
      }
      
      public function clearEffectIcon() : void
      {
         this.release();
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.release();
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
