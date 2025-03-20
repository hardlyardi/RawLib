--!nocheck

local xpcall = xpcall
local debug_info = debug.info
local select = select

-- has a fallback under the unlikely scenario this behavior stops working
local function fetch<T>(call: () -> (), fallback: T): T
	local output = select(
		2,
		xpcall(call, function()
			return debug_info(2, "f")
		end)
	)
	return ((typeof(output) == "function") and output)
		or warn(debug.traceback(`raw call is not available`))
		or fallback
end

local function __indexFetch<T>(item: T)
	return fetch(function()
		return item[nil]
	end, function<T, Idx>(tbl: T, idx: Idx): index<T, Idx>
		return tbl[idx]
	end)
end
local function __newindexFetch<T>(item: T)
	return fetch(function()
		item[""] = nil
	end, function<T, Idx>(tbl: T, idx: Idx, value: index<T, Idx>)
		tbl[idx] = value
	end)
end
local function __addFetch<T>(item: T): <Key>(T, Key & keyof<T>, index<T, Key>) -> ()
	return fetch(function()
		return item + nil
	end, function<Left, Right>(left: Left, right: Right)
		return left + right
	end)
end
local function __subFetch<T>(item: T): <Key>(T, Key & keyof<T>, index<T, Key>) -> ()
	return fetch(function()
		return item - nil
	end, function<Left, Right>(left: Left, right: Right)
		return left - right
	end)
end
local function __mulFetch<T>(item: T): <Key>(T, Key & keyof<T>, index<T, Key>) -> ()
	return fetch(function()
		return item * nil
	end, function<Left, Right>(left: Left, right: Right)
		return left * right
	end)
end
local function __divFetch<T>(item: T): <Key>(T, Key & keyof<T>, index<T, Key>) -> ()
	return fetch(function()
		return item / nil
	end, function<Left, Right>(left: Left, right: Right)
		return left / right
	end)
end
local function __idivFetch<T>(item: T): <Key>(T, Key & keyof<T>, index<T, Key>) -> ()
	return fetch(function()
		return item // nil
	end, function<Left, Right>(left: Left, right: Right)
		return left // right
	end)
end

local RawLib = {
	fetch = fetch
}

--stylua: ignore start
RawLib.instance_index = __indexFetch(workspace) :: (table: Instance, index: keyof<Instance> | string) -> any
RawLib.instance_newindex = __newindexFetch(workspace) :: (table: Instance, index: keyof<Instance> | string, value: any) -> ()

RawLib.cframe_index = __indexFetch(CFrame.identity) :: (table: CFrame, index: keyof<CFrame>) -> any
RawLib.cframe_mul   = __mulFetch(CFrame.identity) :: (table: CFrame, value: CFrame | Vector3) -> CFrame | Vector3
RawLib.cframe_add   = __addFetch(CFrame.identity) :: (table: CFrame, value: Vector3) -> CFrame
RawLib.cframe_sub   = __subFetch(CFrame.identity) :: (table: CFrame, value: Vector3) -> CFrame

RawLib.vector2_index = __indexFetch(Vector2.zero) :: (table: Vector2, index: keyof<Vector2>) -> any
RawLib.vector2_add   = __addFetch(Vector2.zero) :: (table: Vector2, value: Vector2) -> Vector2
RawLib.vector2_sub   = __subFetch(Vector2.zero) :: (table: Vector2, value: Vector2) -> Vector2
RawLib.vector2_mul   = __mulFetch(Vector2.zero) :: (table: Vector2, value: Vector2 | number) -> Vector2
RawLib.vector2_div   = __divFetch(Vector2.zero) :: (table: Vector2, value: Vector2 | number) -> Vector2
RawLib.vector2_idiv  = __idivFetch(Vector2.zero) :: (table: Vector2, value: Vector2 | number) -> Vector2

RawLib.udim_index = __indexFetch(UDim.new(0, 0)) :: (table: UDim, index: keyof<UDim>) -> any
RawLib.udim_add   = __addFetch(UDim.new(0, 0)) :: (table: UDim, value: UDim) -> UDim
RawLib.udim_sub   = __subFetch(UDim.new(0, 0)) :: (table: UDim, value: UDim) -> UDim

RawLib.udim2_index = __indexFetch(UDim2.new(0, 0)) :: (table: UDim2, index: keyof<UDim2>) -> any
RawLib.udim2_add   = __addFetch(UDim2.new(0, 0)) :: (table: UDim2, value: UDim2) -> UDim2
RawLib.udim2_sub   = __subFetch(UDim2.new(0, 0)) :: (table: UDim2, value: UDim2) -> UDim2

RawLib.rect_index = __indexFetch(Rect.new()) :: (table: Rect, index: keyof<Rect>) -> any

RawLib.color_index = __indexFetch(Color3.new()) :: (table: Color3, keyof<Color3>) -> any
--stylua: ignore end

return RawLib
