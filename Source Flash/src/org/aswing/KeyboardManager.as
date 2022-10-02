package org.aswing
{
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import org.aswing.util.ASWingVector;
   
   [Event(name="keyDown",type="flash.events.KeyboardEvent")]
   [Event(name="keyUp",type="flash.events.KeyboardEvent")]
   public class KeyboardManager extends EventDispatcher
   {
      
      private static var instance:KeyboardManager;
       
      
      private var keymaps:ASWingVector;
      
      private var keySequence:ASWingVector;
      
      private var selfKeyMap:KeyMap;
      
      private var inited:Boolean;
      
      private var keyJustActed:Boolean;
      
      public var isStopDispatching:Boolean;
      
      private var mnemonicModifier:Array;
      
      public function KeyboardManager()
      {
         super();
         this.inited = false;
         this.keyJustActed = false;
         this.keymaps = new ASWingVector();
         this.keySequence = new ASWingVector();
         this.selfKeyMap = new KeyMap();
         this.mnemonicModifier = [Keyboard.CONTROL,Keyboard.SHIFT];
         this.registerKeyMap(this.selfKeyMap);
      }
      
      public static function getInstance() : KeyboardManager
      {
         if(instance == null)
         {
            instance = new KeyboardManager();
         }
         return instance;
      }
      
      public static function isDown(param1:uint) : Boolean
      {
         return getInstance().isKeyDown(param1);
      }
      
      public function init(param1:Stage) : void
      {
         if(!this.inited)
         {
            this.inited = true;
            param1.addEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDown,false,0,true);
            param1.addEventListener(KeyboardEvent.KEY_UP,this.__onKeyUp,false,0,true);
            param1.addEventListener(Event.DEACTIVATE,this.__deactived,false,0,true);
         }
      }
      
      override public function dispatchEvent(param1:Event) : Boolean
      {
         if(this.isStopDispatching)
         {
            return false;
         }
         return super.dispatchEvent(param1);
      }
      
      public function registerKeyMap(param1:KeyMap) : void
      {
         if(!this.keymaps.contains(param1))
         {
            this.keymaps.append(param1);
         }
      }
      
      public function unregisterKeyMap(param1:KeyMap) : void
      {
         this.keymaps.remove(param1);
      }
      
      public function registerKeyAction(param1:KeyType, param2:Function) : void
      {
         this.selfKeyMap.registerKeyAction(param1,param2);
      }
      
      public function unregisterKeyAction(param1:KeyType, param2:Function) : void
      {
         this.selfKeyMap.unregisterKeyAction(param1,param2);
      }
      
      public function isKeyDown(param1:uint) : Boolean
      {
         return this.keySequence.contains(param1);
      }
      
      public function setMnemonicModifier(param1:Array) : void
      {
         this.mnemonicModifier = param1.concat();
      }
      
      public function isMnemonicModifierDown() : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.mnemonicModifier.length)
         {
            if(!this.isKeyDown(this.mnemonicModifier[_loc1_]))
            {
               return false;
            }
            _loc1_++;
         }
         return this.mnemonicModifier.length > 0;
      }
      
      public function isKeyJustActed() : Boolean
      {
         return this.keyJustActed;
      }
      
      private function __onKeyDown(param1:KeyboardEvent) : void
      {
         var _loc5_:KeyMap = null;
         this.dispatchEvent(param1);
         var _loc2_:uint = param1.keyCode;
         if(!this.keySequence.contains(_loc2_) && _loc2_ < 139)
         {
            this.keySequence.append(_loc2_);
         }
         this.keyJustActed = false;
         var _loc3_:int = this.keymaps.size();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = KeyMap(this.keymaps.get(_loc4_));
            if(_loc5_.fireKeyAction(this.keySequence.toArray()))
            {
               this.keyJustActed = true;
            }
            _loc4_++;
         }
      }
      
      private function __onKeyUp(param1:KeyboardEvent) : void
      {
         this.dispatchEvent(param1);
         var _loc2_:uint = param1.keyCode;
         this.keySequence.remove(_loc2_);
         if(!param1.ctrlKey)
         {
            this.keySequence.remove(Keyboard.CONTROL);
         }
         if(!param1.shiftKey)
         {
            this.keySequence.remove(Keyboard.SHIFT);
         }
      }
      
      private function __deactived(param1:Event) : void
      {
         this.keySequence.clear();
      }
      
      public function reset() : void
      {
         this.keySequence.clear();
      }
   }
}
