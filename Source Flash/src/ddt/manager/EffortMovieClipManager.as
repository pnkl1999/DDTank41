package ddt.manager
{
   import com.pickgliss.manager.CacheSysManager;
   import ddt.constants.CacheConsts;
   import ddt.data.effort.EffortInfo;
   import ddt.data.effort.EffortRewardInfo;
   import ddt.states.StateType;
   import effortView.movieClip.EffortHonorMovieClipView;
   import effortView.movieClip.EffortMovieClipView;
   import flash.events.Event;
   
   public class EffortMovieClipManager
   {
      
      private static var _instance:EffortMovieClipManager;
       
      
      private var infoQueue:Array;
      
      private var currentMoive:EffortMovieClipView;
      
      private var currentHonorMoive:EffortHonorMovieClipView;
      
      public function EffortMovieClipManager()
      {
         super();
         this.infoQueue = [];
      }
      
      public static function get Instance() : EffortMovieClipManager
      {
         if(_instance == null)
         {
            _instance = new EffortMovieClipManager();
         }
         return _instance;
      }
      
      public function addQueue(param1:EffortInfo) : void
      {
         if(!this.infoQueue)
         {
            this.infoQueue = [];
         }
         if(this.infoQueue.length > 5)
         {
            return;
         }
         this.infoQueue.push(param1);
         if(StateManager.currentStateType != StateType.FIGHTING && StateManager.currentStateType != StateType.FIGHT_LIB_GAMEVIEW)
         {
            this.playMovie();
         }
      }
      
      public function show() : void
      {
         this.playMovie();
      }
      
      public function stop() : void
      {
         if(this.currentHonorMoive)
         {
            this.currentHonorMoive.removeEventListener(EffortMovieClipView.MOVIE_END,this.__honorMovieEnd);
            this.currentHonorMoive.dispose();
         }
         this.currentHonorMoive = null;
         if(this.currentMoive)
         {
            this.currentMoive.removeEventListener(EffortMovieClipView.MOVIE_END,this.__movieEnd);
            this.currentMoive.dispose();
         }
         this.currentMoive = null;
         this.infoQueue = null;
      }
      
      private function playMovie() : void
      {
         if(this.infoQueue && this.infoQueue[0])
         {
            CacheSysManager.lock(CacheConsts.ALERT_IN_MOVIE);
            if(!this.currentMoive)
            {
               this.currentMoive = new EffortMovieClipView(this.infoQueue[0]);
               this.currentMoive.addEventListener(EffortMovieClipView.MOVIE_END,this.__movieEnd);
            }
         }
         else
         {
            this.movieEndHandler();
         }
      }
      
      private function playHonorMovie() : void
      {
         if(this.infoQueue && this.infoQueue[0])
         {
            if(!this.currentHonorMoive)
            {
               this.currentHonorMoive = new EffortHonorMovieClipView(this.infoQueue[0]);
               this.currentHonorMoive.addEventListener(EffortMovieClipView.MOVIE_END,this.__honorMovieEnd);
            }
         }
         else
         {
            this.movieEndHandler();
         }
      }
      
      private function movieEndHandler() : void
      {
         CacheSysManager.unlock(CacheConsts.ALERT_IN_MOVIE);
         CacheSysManager.getInstance().release(CacheConsts.ALERT_IN_MOVIE,1000);
      }
      
      private function __movieEnd(param1:Event) : void
      {
         var _loc2_:int = 0;
         if(this.currentMoive)
         {
            this.currentMoive.removeEventListener(EffortMovieClipView.MOVIE_END,this.__movieEnd);
            this.currentMoive.dispose();
         }
         this.currentMoive = null;
         if(this.infoQueue[0] && this.infoQueue[0].effortRewardArray)
         {
            _loc2_ = 0;
            while(_loc2_ < this.infoQueue[0].effortRewardArray.length)
            {
               if((this.infoQueue[0].effortRewardArray[_loc2_] as EffortRewardInfo).RewardType == 1)
               {
                  this.playHonorMovie();
               }
               _loc2_++;
            }
         }
         else
         {
            this.infoQueue.shift();
            this.playMovie();
         }
      }
      
      private function __honorMovieEnd(param1:Event) : void
      {
         if(this.currentHonorMoive)
         {
            this.currentHonorMoive.removeEventListener(EffortMovieClipView.MOVIE_END,this.__honorMovieEnd);
            this.currentHonorMoive.dispose();
         }
         this.currentHonorMoive = null;
         if(this.currentMoive)
         {
            this.currentMoive.removeEventListener(EffortMovieClipView.MOVIE_END,this.__movieEnd);
            this.currentMoive.dispose();
         }
         this.currentMoive = null;
         this.infoQueue.shift();
         this.playMovie();
      }
   }
}
