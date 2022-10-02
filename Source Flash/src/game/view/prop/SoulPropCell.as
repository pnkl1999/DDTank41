package game.view.prop
{
   import ddt.view.tips.ToolPropInfo;
   
   public class SoulPropCell extends PropCell
   {
       
      
      public function SoulPropCell()
      {
         super();
         _tipInfo.valueType = ToolPropInfo.Psychic;
      }
      
      override public function setPossiton(param1:int, param2:int) : void
      {
         super.setPossiton(param1,param2);
         this.x = _x;
         this.y = _y;
      }
   }
}
