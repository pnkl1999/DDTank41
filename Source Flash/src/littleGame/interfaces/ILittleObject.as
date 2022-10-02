package littleGame.interfaces
{
   import com.pickgliss.ui.core.Disposeable;
   import littleGame.model.Scenario;
   import road7th.comm.PackageIn;
   
   public interface ILittleObject extends Disposeable
   {
       
      
      function initialize(param1:Scenario, param2:PackageIn) : void;
      
      function get id() : int;
      
      function execute() : void;
      
      function toString() : String;
      
      function get type() : String;
      
      function invoke(param1:PackageIn) : void;
   }
}
