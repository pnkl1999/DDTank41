package littleGame.interfaces
{
   import com.pickgliss.ui.core.Disposeable;
   import flash.display.DisplayObjectContainer;
   import littleGame.model.Scenario;
   import road7th.comm.PackageIn;
   
   public interface ISchedule extends Disposeable
   {
       
      
      function get id() : int;
      
      function update() : void;
      
      function initialize(param1:Scenario, param2:PackageIn, param3:DisplayObjectContainer = null) : void;
      
      function invoke(param1:PackageIn) : void;
      
      function get running() : Boolean;
   }
}
