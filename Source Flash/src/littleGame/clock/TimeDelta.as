package littleGame.clock
{
   public class TimeDelta
   {
       
      
      private var _latency:int;
      
      private var _timeSyncDelta:int;
      
      public function TimeDelta(latency:int, timeSyncDelta:int)
      {
         super();
         this._latency = latency;
         this._timeSyncDelta = timeSyncDelta;
      }
      
      public function get latency() : int
      {
         return this._latency;
      }
      
      public function get timeSyncDelta() : int
      {
         return this._timeSyncDelta;
      }
   }
}
