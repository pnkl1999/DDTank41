package guildMemberWeek.data
{
   public class GuildMemberWeekItemsInfo
   {
       
      
      public var ActivityType:int;
      
      public var Quality:int;
      
      public var TemplateID:int;
      
      public var ValidDate:int;
      
      public var Count:int = 1;
      
      public var IsBind:Boolean;
      
      public var StrengthLevel:int;
      
      public var AttackCompose:int;
      
      public var DefendCompose:int;
      
      public var AgilityCompose:int;
      
      public var LuckCompose:int;
      
      public function GuildMemberWeekItemsInfo(param1:int = 0, param2:int = 0)
      {
         super();
         this.Quality = param1;
         this.TemplateID = param2;
      }
   }
}
