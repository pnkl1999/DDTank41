package game.view.smallMap
{
   import flash.display.Graphics;
   import game.model.Living;
   import phy.object.SmallObject;
   
   public class SmallLiving extends SmallObject
   {
       
      
      protected var _info:Living;
      
      public function SmallLiving()
      {
         super();
      }
      
      public function set info(param1:Living) : void
      {
         this._info = param1;
         this.fitInfo();
      }
      
      public function get info() : Living
      {
         return this._info;
      }
      
      override protected function draw() : void
      {
         var _loc1_:Graphics = graphics;
         _loc1_.clear();
         _loc1_.beginFill(_color);
         _loc1_.drawCircle(0,0,_radius);
         _loc1_.endFill();
      }
      
      protected function fitInfo() : void
      {
         switch(this._info.team)
         {
            case 1:
               color = 13260;
               break;
            case 2:
               color = 16711680;
               break;
            case 3:
               color = 16763904;
               break;
            case 4:
               color = 10079232;
               break;
            case 5:
               color = 6697932;
               break;
            case 6:
               color = 10053171;
               break;
            case 7:
               color = 16751052;
               break;
            case 8:
            default:
               color = 3381606;
         }
      }
   }
}
