package game.view.experience
{
   import com.greensock.TimelineMax;
   import com.greensock.core.TweenCore;
   
   public class ExpTweenManager
   {
      
      private static var _instance:ExpTweenManager;
       
      
      public var isPlaying:Boolean;
      
      private var _timeline:TimelineMax;
      
      private var _tweens:Vector.<TweenCore>;
      
      public function ExpTweenManager()
      {
         super();
         this.init();
      }
      
      public static function get Instance() : ExpTweenManager
      {
         if(!_instance)
         {
            _instance = new ExpTweenManager();
         }
         return _instance;
      }
      
      private function init() : void
      {
         this._timeline = new TimelineMax();
         this._timeline.autoRemoveChildren = true;
         this._timeline.stop();
         this._tweens = new Vector.<TweenCore>();
      }
      
      public function appendTween(param1:TweenCore, param2:Number = 0, param3:Object = null) : void
      {
         this._tweens.push(param1);
         this._timeline.append(param1,param2);
         if(param3 != null)
         {
            if(param3.onStart != null && param3.onStartParams != null)
            {
               param1.vars.onStart = param3.onStart;
               param1.vars.onStartParams = param3.onStartParams;
            }
            else if(param3.onStart != null)
            {
               param1.vars.onStart = param3.onStart;
            }
            if(param3.onComplete != null && param3.onCompleteParams != null)
            {
               param1.vars.onComplete = param3.onComplete;
               param1.vars.onCompleteParams = param3.onCompleteParams;
            }
            else if(param3.onComplete != null)
            {
               param1.vars.onComplete = param3.onComplete;
            }
         }
      }
      
      public function startTweens() : void
      {
         this._timeline.play();
      }
      
      public function completeTweens() : void
      {
         this._timeline.timeScale = 100;
      }
      
      public function speedRecover() : void
      {
         this._timeline.timeScale = 1;
      }
      
      public function deleteTweens() : void
      {
         var _loc1_:TweenCore = null;
         this._timeline.stop();
         while(this._tweens.length > 0)
         {
            _loc1_ = this._tweens.shift();
            _loc1_.kill();
            _loc1_ = null;
         }
         this._tweens = new Vector.<TweenCore>();
         this._timeline.kill();
         this._timeline.clear();
         this._timeline.totalProgress = 0;
         this._timeline = new TimelineMax();
      }
   }
}
