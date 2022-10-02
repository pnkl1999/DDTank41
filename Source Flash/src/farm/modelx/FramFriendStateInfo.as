package farm.modelx
{
   import ddt.data.player.FriendListPlayer;
   import ddt.manager.PlayerManager;
   
   public class FramFriendStateInfo
   {
       
      
      public var id:int;
      
      public var landStateVec:Vector.<SimpleLandStateInfo>;
      
      public function FramFriendStateInfo()
      {
         super();
         this.landStateVec = new Vector.<SimpleLandStateInfo>();
      }
      
      public function get playerinfo() : FriendListPlayer
      {
         return PlayerManager.Instance.friendList[this.id];
      }
      
      public function get hasGrownLand() : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.landStateVec.length)
         {
            if(this.landStateVec[_loc1_].hasPlantGrown)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      public function get isStolen() : Boolean
      {
         var _loc1_:int = 0;
         if(this.hasGrownLand)
         {
            _loc1_ = 0;
            while(_loc1_ < this.landStateVec.length)
            {
               if(this.landStateVec[_loc1_].isStolen)
               {
                  return true;
               }
               _loc1_++;
            }
         }
         return false;
      }
      
      public function set setLandStateVec(param1:Vector.<SimpleLandStateInfo>) : void
      {
         this.landStateVec = param1;
      }
   }
}
