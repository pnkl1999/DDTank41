package hallIcon.info
{
   public class HallIconInfo
   {
       
      
      public var halltype:int;
      
      public var icontype:String;
      
      public var isopen:Boolean;
      
      public var timemsg:String;
      
      public var fightover:Boolean;
      
      public var orderid:int;
      
      public var num:int;
      
      public function HallIconInfo($icontype:String = "", $isopen:Boolean = false, $timemsg:String = null, $halltype:int = 0, $fightover:Boolean = false, $orderid:int = 0, $num:int = -1)
      {
         super();
         this.icontype = $icontype;
         this.isopen = $isopen;
         this.timemsg = $timemsg;
         this.halltype = $halltype;
         this.fightover = $fightover;
         this.orderid = $orderid;
         this.num = $num;
      }
   }
}
