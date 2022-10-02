package petsBag.petsAdvanced
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.data.analyze.PetMoePropertyAnalyzer;
   import ddt.manager.LanguageMgr;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import petsBag.data.PetFightPropertyData;
   import petsBag.data.PetMoePropertyInfo;
   import petsBag.data.PetStarExpData;
   import petsBag.data.PetsFormData;
   
   public class PetsAdvancedManager extends EventDispatcher
   {
      
      private static var _instance:PetsAdvancedManager;
       
      
      public var currentViewType:int;
      
      public var risingStarDataList:Vector.<PetStarExpData>;
      
      public var evolutionDataList:Vector.<PetFightPropertyData>;
      
      public var formDataList:Vector.<PetsFormData>;
      
      public var isAllMovieComplete:Boolean = true;
      
      public var isPetsAdvancedViewShow:Boolean;
      
      public var frame:PetsAdvancedFrame;
      
      public var petMoePropertyList:Vector.<PetMoePropertyInfo>;
      
      public function PetsAdvancedManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get Instance() : PetsAdvancedManager
      {
         if(_instance == null)
         {
            _instance = new PetsAdvancedManager();
         }
         return _instance;
      }
      
      public function risingStarDataComplete(param1:PetsRisingStarDataAnalyzer) : void
      {
         this.risingStarDataList = param1.list;
      }
      
      public function evolutionDataComplete(param1:PetsEvolutionDataAnalyzer) : void
      {
         this.evolutionDataList = param1.list;
      }
      
      public function formDataComplete(param1:PetsFormDataAnalyzer) : void
      {
         this.formDataList = param1.list;
      }
       
      public function moePropertyComplete(param1:PetMoePropertyAnalyzer) : void
      {
         this.petMoePropertyList = param1.list;
      }
      
      public function showPetsAdvancedFrame() : void
      {
         this.frame = ComponentFactory.Instance.creatCustomObject("petsBag.PetsAdvancedFrame");
         this.frame.titleText = LanguageMgr.GetTranslation("ddt.pets.advancedTxt");
         LayerManager.Instance.addToLayer(this.frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function getFormDataIndexByTempId(param1:int) : int
      {
         var _loc2_:int = -1;
         var _loc3_:int = 0;
         while(_loc3_ < this.formDataList.length)
         {
            if(param1 == this.formDataList[_loc3_].TemplateID)
            {
               _loc2_ = _loc3_;
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
   }
}
