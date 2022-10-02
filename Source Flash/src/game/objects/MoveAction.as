package game.objects
{
   public class MoveAction
   {
       
      
      private var _type:int;
      
      public function MoveAction()
      {
         super();
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function execute() : void
      {
         switch(this._type)
         {
            case 1:
         }
      }
   }
}
