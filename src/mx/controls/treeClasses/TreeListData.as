package mx.controls.treeClasses
{
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.ListBase;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class TreeListData extends BaseListData
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      [Bindable("__NoChangeEvent__")]
      public var depth:int;
      
      [Bindable("__NoChangeEvent__")]
      public var disclosureIcon:Class;
      
      [Bindable("__NoChangeEvent__")]
      public var hasChildren:Boolean;
      
      [Bindable("__NoChangeEvent__")]
      public var icon:Class;
      
      [Bindable("__NoChangeEvent__")]
      public var indent:int;
      
      [Bindable("__NoChangeEvent__")]
      public var item:Object;
      
      [Bindable("__NoChangeEvent__")]
      public var open:Boolean;
      
      public function TreeListData(param1:String, param2:String, param3:ListBase, param4:int = 0, param5:int = 0)
      {
         super(param1,param2,param3,param4,param5);
      }
   }
}

