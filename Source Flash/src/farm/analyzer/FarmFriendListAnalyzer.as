package farm.analyzer
{
   import com.pickgliss.loader.DataAnalyzer;
   import farm.modelx.FramFriendStateInfo;
   import farm.modelx.SimpleLandStateInfo;
   import road7th.data.DictionaryData;
   import road7th.utils.DateUtils;
   
   public class FarmFriendListAnalyzer extends DataAnalyzer
   {
       
      
      public var list:DictionaryData;
      
      public function FarmFriendListAnalyzer(param1:Function)
      {
         this.list = new DictionaryData();
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc4_:XML = null;
         var _loc5_:FramFriendStateInfo = null;
         var _loc6_:Vector.<SimpleLandStateInfo> = null;
         var _loc7_:XMLList = null;
         var _loc8_:XML = null;
         var _loc9_:SimpleLandStateInfo = null;
         var _loc2_:XML = XML(param1);
         var _loc3_:XMLList = _loc2_.Item;
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = new FramFriendStateInfo();
            _loc5_.id = _loc4_.@UserID;
            _loc6_ = new Vector.<SimpleLandStateInfo>();
            _loc7_ = _loc4_.Item;
            for each(_loc8_ in _loc7_)
            {
               _loc9_ = new SimpleLandStateInfo();
               _loc9_.seedId = _loc8_.@SeedID;
               _loc9_.AccelerateDate = _loc8_.@AcclerateDate;
               _loc9_.plantTime = DateUtils.decodeDated(_loc8_.@GrowTime);
               _loc9_.isStolen = _loc8_.@IsCanStolen == "true" ? Boolean(Boolean(true)) : Boolean(Boolean(false));
               _loc6_.push(_loc9_);
            }
            _loc5_.setLandStateVec = _loc6_;
            this.list.add(_loc5_.id,_loc5_);
         }
         onAnalyzeComplete();
      }
   }
}
