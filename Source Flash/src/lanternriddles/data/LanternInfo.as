package lanternriddles.data
{
   public class LanternInfo
   {
       
      
      public var QuestionIndex:int;
      
      public var QuestionID:int;
      
      public var Count:int;
      
      public var EndDate:Date;
      
      public var Option:int;
      
      public var QuestionContent:String;
      
      public var Option1:String;
      
      public var Option2:String;
      
      public var Option3:String;
      
      public var Option4:String;
      
      public var Rank:int;
      
      public var NickName:String;
      
      public var TypeVIP:int;
      
      public var Integer:int;
      
      public var AwardInfoVec:Vector.<LanternAwardInfo>;
      
      public function LanternInfo()
      {
         this.AwardInfoVec = new Vector.<LanternAwardInfo>();
         super();
      }
      
      public function get IsVIP() : Boolean
      {
         return this.TypeVIP >= 1;
      }
   }
}
