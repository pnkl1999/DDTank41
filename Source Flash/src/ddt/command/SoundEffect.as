package ddt.command
{
   import com.pickgliss.ui.core.Disposeable;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundEffectManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.utils.getTimer;
   
   public class SoundEffect extends EventDispatcher implements Disposeable
   {
       
      
      private var _id:String;
      
      private var _delay:int;
      
      private var _sound:Sound;
      
      private var _channel:SoundChannel;
      
      public function SoundEffect(param1:String)
      {
         super();
         this._id = param1;
         this.init();
      }
      
      private function init() : void
      {
         var _loc1_:* = SoundEffectManager.Instance.definition(this._id);
         this._sound = new _loc1_();
         this._channel = new SoundChannel();
         this._channel.soundTransform = new SoundTransform(SharedManager.Instance.soundVolumn);
         this._channel.addEventListener(Event.SOUND_COMPLETE,this.__onSoundComplete);
      }
      
      public function play() : void
      {
         this._delay = getTimer();
         this._channel = this._sound.play();
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function get delay() : int
      {
         return this._delay;
      }
      
      private function __onSoundComplete(param1:Event) : void
      {
         dispatchEvent(new Event(Event.SOUND_COMPLETE));
      }
      
      public function dispose() : void
      {
         this._id = null;
         if(this._sound)
         {
            this._sound.close();
         }
         this._sound = null;
         if(this._channel)
         {
            this._channel.stop();
         }
         this._channel = null;
      }
   }
}
