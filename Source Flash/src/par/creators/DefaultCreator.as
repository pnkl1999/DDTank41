package par.creators
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class DefaultCreator implements IParticalCreator
   {
       
      
      public function DefaultCreator()
      {
         super();
      }
      
      public function createPartical() : DisplayObject
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(0);
         _loc1_.graphics.drawCircle(0,0,10);
         _loc1_.graphics.endFill();
         return _loc1_;
      }
   }
}
