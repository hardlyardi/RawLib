--!optimize 2
--!strict 
--This module will pobably be patched

--this function returns the metamethod and also tries to predict if it was patched
local function returnFunc()
	local returnV = debug.info(2,"f")
	
	if returnV == error then
		return nil
	end
	
	return returnV
end

--those functions were meant to error so please do not call them
local function index(table:any,index:string) : any return table[index] end
local function newIndex(table:any,index:string,value:any) : () table[index] = value end

local function mul(table:any,value:number) : any return table*value end
local function add(table:any,value:number) : any return table+value end
local function sub(table:any,value:number) : any return table-value end
local function div(table:any,value:number) : any return table/value end
local function fdiv(table:any,value:number) : any return table//value end

type RawLib = {
	instance_index:(table:Instance,index:keyof<Instance>|string) -> any;
	instance_newindex:(table:Instance,index:keyof<Instance>|string,value:any) -> ();
	
	cframe_index:(table:CFrame,index:keyof<CFrame>) -> any;
	cframe_mul:(table:CFrame,value:CFrame|Vector3) -> CFrame|Vector3;
	cframe_add:(table:CFrame,value:Vector3) -> CFrame;
	cframe_sub:(table:CFrame,value:Vector3) -> CFrame;
	
	vector3_index:(table:Vector3,index:keyof<Vector3>) -> any;
	vector3_add:(table:Vector3,value:Vector3) -> Vector3;
	vector3_sub:(table:Vector3,value:Vector3) -> Vector3;
	vector3_mul:(table:Vector3,value:Vector3|number) -> Vector3;
	vector3_div:(table:Vector3,value:Vector3|number) -> Vector3;
	vector3_fdiv:(table:Vector3,value:Vector3|number) -> Vector3;
	
	vector2_index:(table:Vector2,index:keyof<Vector2>) -> any;
	vector2_add:(table:Vector2,value:Vector2) -> Vector2;
	vector2_sub:(table:Vector2,value:Vector2) -> Vector2;
	vector2_mul:(table:Vector2,value:Vector2|number) -> Vector2;
	vector2_div:(table:Vector2,value:Vector2|number) -> Vector2;
	
	udim_index:(table:UDim,index:keyof<UDim>) -> any;
	udim_add:(table:UDim,value:UDim) -> UDim;
	udim_sub:(table:UDim,value:UDim) -> UDim;
	
	udim2_index:(table:UDim2,index:keyof<UDim2>) -> any;
	udim2_add:(table:UDim2,value:UDim2) -> UDim2;
	udim2_sub:(table:UDim2,value:UDim2) -> UDim2;
	
	rect_index:(table:Rect,index:keyof<Rect>) -> any;
	color_index:(table:Color3,keyof<Color3>) -> any;
}

--There is a better method to organize all of them... Too bad!
local RawLib:RawLib = {
	instance_index = select(2,xpcall(index,returnFunc,game,"")) or warn("Instance index raw call is not available") and index::any;
	instance_newindex = select(2,xpcall(newIndex,returnFunc,game,"",nil)) or warn("Instance newIndex raw call is not available") and newIndex::any;
	
	cframe_index = select(2,xpcall(index,returnFunc,CFrame.identity,"")) or warn("CFrame index raw call is not available") and index::any;
	cframe_add = select(2,xpcall(add,returnFunc,CFrame.identity,nil)) or warn("CFrame add raw call is not available") and add::any;
	cframe_sub = select(2,xpcall(sub,returnFunc,CFrame.identity,nil)) or warn("CFrame sub raw call is not available") and sub::any;
	cframe_mul = select(2,xpcall(mul,returnFunc,CFrame.identity,nil)) or warn("CFrame mul raw call is not available") and mul::any;
	
	vector3_index = select(2,xpcall(index,returnFunc,Vector3.zero,"")) or warn("Vector3 index raw call is not available") and index::any;
	vector3_add = select(2,xpcall(add,returnFunc,Vector3.zero,nil)) or warn("Vector3 add raw call is not available") and add::any;
	vector3_div = select(2,xpcall(div,returnFunc,Vector3.zero,nil)) or warn("Vector3 div raw call is not available") and div::any;
	vector3_mul = select(2,xpcall(mul,returnFunc,Vector3.zero,nil)) or warn("Vector3 mul raw call is not available") and mul::any;
	vector3_sub = select(2,xpcall(sub,returnFunc,Vector3.zero,nil)) or warn("Vector3 sub raw call is not available") and sub::any;
	vector3_fdiv = select(2,xpcall(fdiv,returnFunc,Vector3.zero,nil)) or warn("Vector3 fdiv raw call is not available") and fdiv::any;
	
	vector2_index = select(2,xpcall(index,returnFunc,Vector2.zero,"")) or warn("Vector2 index raw call is not available") and index::any;
	vector2_add = select(2,xpcall(add,returnFunc,Vector2.zero,nil)) or warn("Vector2 add raw call is not available") and add::any;
	vector2_div = select(2,xpcall(div,returnFunc,Vector2.zero,nil)) or warn("Vector2 div raw call is not available") and div::any;
	vector2_mul = select(2,xpcall(mul,returnFunc,Vector2.zero,nil)) or warn("Vector2 mul raw call is not available") and mul::any;
	vector2_sub = select(2,xpcall(sub,returnFunc,Vector2.zero,nil)) or warn("Vector2 sub raw call is not available") and sub::any;
	
	udim_index = select(2,xpcall(index,returnFunc,UDim.new(),"")) or warn("UDim index raw call is not available") and index::any;
	udim_sub = select(2,xpcall(sub,returnFunc,UDim.new(),"")) or warn("UDim sub raw call is not available") and sub::any;
	udim_add = select(2,xpcall(add,returnFunc,UDim.new(),"")) or warn("UDim add raw call is not available") and add::any;
	
	udim2_index = select(2,xpcall(index,returnFunc,UDim2.new(),"")) or warn("UDim2 index raw call is not available") and index::any;
	udim2_sub = select(2,xpcall(sub,returnFunc,UDim2.new(),"")) or warn("UDim2 sub raw call is not available") and sub::any;
	udim2_add = select(2,xpcall(add,returnFunc,UDim2.new(),"")) or warn("UDim2 add raw call is not available") and add::any;
	
	rect_index = select(2,xpcall(index,returnFunc,Rect.new(),"")) or warn("Instance index raw call is not available") and index::any;
	color_index = select(2,xpcall(index,returnFunc,Color3.new(),"")) or warn("Instance index raw call is not available") and index::any;
}

return RawLib
