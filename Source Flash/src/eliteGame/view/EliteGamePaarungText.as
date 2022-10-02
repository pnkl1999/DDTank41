package eliteGame.view
{
   import com.pickgliss.ui.text.FilterFrameText;
   
   public class EliteGamePaarungText extends FilterFrameText
   {
       
      
      private var _acceptRankArr:Array;
      
      public var playerId:int;
      
      public function EliteGamePaarungText()
      {
         super();
      }
      
      public function set acceptRank(param1:String) : void
      {
         this._acceptRankArr = param1.split(",");
      }
      
      public function canAccept(param1:int) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._acceptRankArr.length)
         {
            if(param1 == parseInt(this._acceptRankArr[_loc2_]))
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
   }
}
