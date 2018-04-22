
Citizen.CreateThread( function()
	local lastStreetA = 0
	local lastStreetB = 0

	while Config.streetName.show do
		Citizen.Wait(0)

		local playerPos = GetEntityCoords(GetPlayerPed(-1), true)
		local streetA, streetB = Citizen.InvokeNative(0x2EB41072B4C1E4C0, playerPos.x, playerPos.y, playerPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
		local street = {}

		if not ((streetA == lastStreetA or streetA == lastStreetB) and (streetB == lastStreetA or streetB == lastStreetB)) then
			lastStreetA = streetA
			lastStreetB = streetB
		end

		if lastStreetA ~= 0 then
			table.insert(street, GetStreetNameFromHashKey(lastStreetA))
		end

		if lastStreetB ~= 0 then
			table.insert(street, GetStreetNameFromHashKey(lastStreetB))
		end

		drawText(table.concat(street, " & "), Config.streetName.position.x, Config.streetName.position.y, {
			size = Config.streetName.textSize,
			colour = Config.streetName.textColour,
			outline = true,
			centered = Config.streetName.position.centered,
			font = 1,
			size = 0.55
		})
	end
end)
