package room.model
{
   import ddt.events.WebSpeedEvent;
   import ddt.manager.LanguageMgr;
   import flash.events.EventDispatcher;
   
   [Event(name="stateChange",type="tank.view.game.webspeed.WebSpeedEvent")]
   public class WebSpeedInfo extends EventDispatcher
   {
      
      public static const BEST:String = LanguageMgr.GetTranslation("tank.data.WebSpeedInfo.good");
      
      public static const BETTER:String = LanguageMgr.GetTranslation("tank.data.WebSpeedInfo.find");
      
      public static const WORST:String = LanguageMgr.GetTranslation("tank.data.WebSpeedInfo.bad");
       
      
      private var _fps:int;
      
      private var _delay:int;
      
      public function WebSpeedInfo(param1:int)
      {
         super();
         this._delay = param1;
      }
      
      public function get fps() : int
      {
         return this._fps;
      }
      
      public function set fps(param1:int) : void
      {
         if(this._fps == param1)
         {
            return;
         }
         this._fps = param1;
         dispatchEvent(new WebSpeedEvent(WebSpeedEvent.STATE_CHANE));
      }
      
      public function get delay() : int
      {
         return this._delay;
      }
      
      public function set delay(param1:int) : void
      {
         if(this._delay == param1)
         {
            return;
         }
         this._delay = param1;
         dispatchEvent(new WebSpeedEvent(WebSpeedEvent.STATE_CHANE));
      }
      
      public function get stateId() : int
      {
         if(this._delay > 600)
         {
            return 3;
         }
         if(this._delay > 300)
         {
            return 2;
         }
         return 1;
      }
      
      public function get state() : String
      {
         if(this._delay > 600)
         {
            return WORST;
         }
         if(this._delay > 300)
         {
            return BETTER;
         }
         return BEST;
      }
   }
}
