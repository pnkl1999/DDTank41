package tryonSystem
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import equipretrieve.effect.AnimationControl;
   import equipretrieve.effect.GlowFilterAnimation;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import quest.QuestRewardCell;
   import quest.TaskMainFrame;
   
   public class ChooseFrame extends BaseAlerFrame
   {
       
      
      private var _control:TryonSystemController;
      
      private var _bg:Bitmap;
      
      private var _cells:Array;
      
      private var _list:SimpleTileList;
      
      public function ChooseFrame()
      {
         super();
         var _loc1_:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("ddt.tryonSystem.title"),"","",true,false);
         _loc1_.submitLabel = LanguageMgr.GetTranslation("ok");
         _loc1_.moveEnable = false;
         info = _loc1_;
      }
      
      public function set controller(param1:TryonSystemController) : void
      {
         this._control = param1;
         this.initView();
      }
      
      private function initView() : void
      {
         var _loc1_:AnimationControl = null;
         var _loc3_:QuestRewardCell = null;
         _loc1_ = null;
         var _loc2_:InventoryItemInfo = null;
         _loc3_ = null;
         var _loc4_:MovieImage = null;
         var _loc5_:GlowFilterAnimation = null;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.tryon.chooseItemBgAsset");
         addToContent(this._bg);
         this._list = new SimpleTileList(2);
         this._list.hSpace = 6;
         this._list.vSpace = -5;
         this._list.x = 14;
         this._list.y = 20;
         addToContent(this._list);
         this._cells = [];
         _loc1_ = new AnimationControl();
         _loc1_.addEventListener(Event.COMPLETE,this._cellLightComplete);
         for each(_loc2_ in this._control.model.items)
         {
            _loc3_ = new QuestRewardCell();
            _loc3_.opitional = true;
            _loc3_.taskType = TaskMainFrame.NORMAL;
            _loc3_.info = _loc2_;
            _loc3_.addEventListener(MouseEvent.CLICK,this.__onclick);
            _loc3_.buttonMode = true;
            this._cells.push(_loc3_);
            this._list.addChild(_loc3_);
            _loc4_ = ComponentFactory.Instance.creatComponentByStylename("asset.core.itemShinelight");
            _loc4_.movie.play();
            _loc3_.addChildAt(_loc4_,1);
            _loc5_ = new GlowFilterAnimation();
            _loc5_.start(_loc4_,false,16763955,0,0);
            _loc5_.addMovie(0,0,19,0);
            _loc1_.addMovies(_loc5_);
         }
         _loc1_.startMovie();
      }
      
      private function _cellLightComplete(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         param1.currentTarget.removeEventListener(Event.COMPLETE,this._cellLightComplete);
         if(this._cells)
         {
            _loc2_ = this._cells.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               this._cells[_loc3_].removeChildAt(1);
               _loc3_++;
            }
         }
      }
      
      private function __onclick(param1:MouseEvent) : void
      {
         var _loc2_:QuestRewardCell = null;
         SoundManager.instance.play("008");
         for each(_loc2_ in this._cells)
         {
            _loc2_.selected = false;
         }
         this._control.model.selectedItem = QuestRewardCell(param1.currentTarget).info;
         QuestRewardCell(param1.currentTarget).selected = true;
      }
      
      override public function dispose() : void
      {
         var _loc1_:QuestRewardCell = null;
         this._control = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         for each(_loc1_ in this._cells)
         {
            _loc1_.removeEventListener(MouseEvent.CLICK,this.__onclick);
            _loc1_.removeChildAt(1);
            _loc1_.dispose();
         }
         this._cells = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._list);
         this._list = null;
         super.dispose();
      }
   }
}
