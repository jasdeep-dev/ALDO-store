import logo from '../logo.png';

export default function Header() {
  return (
    <div>
    <nav className="bg-red-100 fixed w-full">
      <div className="mx-auto flex flex-wrap items-center justify-between w-1/2">
        <div className="flex items-center text-white font-extrabold w-full">
          <div className="p-4 flex items-center mx-auto text-center">
            <img src={logo} className="App-logo h-10" alt="logo" />
            <p className="text-2xl bold ml-2 mt-2 text-gray-600">LDO</p>
          </div>
        </div>
      </div>
    </nav>
  </div>
  );
}
