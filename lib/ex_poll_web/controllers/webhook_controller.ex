defmodule ExPollWeb.WebhookController do
  use ExPollWeb, :controller


  @doc """
  Corresponde a un llamado get con un path param
  curl -H "Content-Type: application/json" -X GET http://localhost:4000/api/person/juan
  """
  def getnameperson(conn, %{"name" => name} = params ) do
    IO.inspect(params)
    json(conn, %{pathparam: name})
  end

  @doc """
  Corresponde a un llamado put que combina pathparam y body
  curl localhost:4000/api/person/1 -X PUT -H "Content-Type: application/json" -d '{ "name": "Juan", "lastname": "Quiroga" }'
  """
  def putperson(conn, %{"id" => id, "lastname" => lastname, "name" => name } = params ) do
    IO.inspect(params)
    fullname = "#{name} #{lastname}"
    json(conn, %{id: id, fullname: fullname })
  end

  @doc """
  Corresponde a un llamado get con un query param (plug se encarga de colocarlo)
  curl -H "Content-Type: application/json" -X GET "http://localhost:4000/api/vehicle?plate=2323"
  """
  def getqueryvehicle(conn, %{"plate" => plate} = params ) do
    IO.inspect(params)
    json(conn, %{queryparam: plate})
  end

 @doc """
  Corresponde al llamado post llega a través del body
  curl localhost:4000/api/person -X POST -H "Content-Type: application/json" -d '{ "message": "Juan" }'
  """
  def postvehicle(conn, %{"message" => message} = params ) do
    IO.inspect(params)
    json(conn, %{body: message})
  end

  @doc """
  Corresponde al llmado get con un header en este caso x-liftit
  curl localhost:4000/api/vehicle/header -X GET -H "Content-Type: application/json" -H "X-Liftit: 12"
  """
  def headervehicle(conn, _params) do
    IO.inspect(conn)
    orgid=get_req_header(conn, "x-liftit")
    conn
    |> json( %{orgid: orgid })
  end

  @doc """
  Corresponde al llamado post con un status 201
  curl localhost:4000/api/vehicle/status -X POST -H "Content-Type: application/json" -verbose
  """
  def statusvehicle(conn, _params ) do
    conn
    |> put_status(:created)
    |> text("")
  end

  @doc """
  Corresponde a llamado post con body tipo array
  curl localhost:4000/api/vehicles -X POST -H "Content-Type: application/json" -d '[ { "plate": "AAA123" }, {"plate": "BBB234"}]'
  """
  def multiplevehicles(conn, params ) do
    IO.inspect(params)
    # Cuando llega un arreglo este se accede vía _json sobre params
    %{"_json"=>data} = params
    conn
    |> json( %{vehicles: data})
  end

  @doc """
  Corresponde a un servicio get que consume un servicio externo
  curl localhost:4000/api/consume -X GET -H "Content-Type: application/json"
  """
  def consumeservice(conn, _params ) do
    response = HTTPoison.get! "https://webhook.site/35a55018-cb75-4d94-b383-8a2e2fd2f56d"
    req = Poison.decode!(response.body)
    IO.inspect(req)
    conn
    |> json( %{response: req})
  end

  def consumeservicedecode(conn, _params ) do
    response = HTTPoison.get! "https://webhook.site/35a55018-cb75-4d94-b383-8a2e2fd2f56d"
    IO.inspect(response.body)
    req = Poison.decode!(response.body, as: %Person{})
    IO.inspect(req)
    conn
    |> json( %{response: "hola"})
  end

  @doc """
  Recupera la información enviada por cada parte raw
  curl "localhost:4000/api/vehicle/raw/1?plata=AAA001&model=1991" -X POST -H "Content-Type: application/json"  -H "x-liftit: 123" --data-binary '{ "message": "Juan", "age": 40 }'
  """
  def postvehicleraw(conn, _params ) do
    IO.inspect(conn.req_headers())

    {_, value} = hd(Enum.filter(conn.req_headers(), fn { key , _ } -> key == "x-liftit" end))
    IO.inspect(value)
    body = conn.body_params()
    IO.inspect(body)
    queryparams = conn.query_params()
    IO.inspect(queryparams)
    pathparams = conn.path_params()
    IO.inspect(pathparams)
    json(conn, %{body: body, queryparams: queryparams, pathparams: pathparams, headers: value})
  end
end
