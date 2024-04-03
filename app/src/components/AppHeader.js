import React, { useState } from 'react';
import {
  MDBContainer,
  MDBNavbar,
  MDBNavbarBrand,
  MDBNavbarToggler,
  MDBIcon,
  MDBNavbarNav,
  MDBNavbarItem,
  MDBNavbarLink,
  MDBDropdown,
  MDBDropdownToggle,
  MDBDropdownMenu,
  MDBDropdownItem,
  MDBCollapse,
  // MDBBtn,
  // MDBTabs,
  // MDBTabsItem,
  // MDBTabsLink,
  // MDBTabsContent,
  // MDBTabsPane
} from 'mdb-react-ui-kit';


const AppHeader = () => {
  const [openNavRight, setOpenNavRight] = useState(false);

  // <MDBNavbar expand='lg' light bgColor='light'>
  return (
    <div className="app-header">
    <MDBNavbar expand='lg' dark bgColor='black'>
      <MDBContainer fluid>
        <MDBNavbarBrand href=''>
          <img
              src='https://mdbootstrap.com/img/logo/mdb-transaprent-noshadows.webp'
              height='30'
              alt=''
              loading='lazy'
            />
          Next-Launcher
          </MDBNavbarBrand>

        <MDBNavbarToggler
          aria-controls='navbarSupportedContent'
          aria-expanded='false'
          aria-label='Toggle navigation'
          onClick={() => setOpenNavRight(!openNavRight)}
        >
          <MDBIcon icon='bars' fas />
        </MDBNavbarToggler>

        <MDBCollapse navbar open={openNavRight}>
          <MDBNavbarNav right fullWidth={false} className='mb-2 mb-lg-0'>
            <MDBNavbarItem>
              <MDBNavbarLink href='/workflows'>
                Workflows
              </MDBNavbarLink>
            </MDBNavbarItem>
            <MDBNavbarItem>
              <MDBNavbarLink href='/visualizer'>
                Visualizer
              </MDBNavbarLink>
            </MDBNavbarItem>

            <MDBNavbarItem>
              <MDBDropdown>
                <MDBDropdownToggle tag='a' className='nav-link'>
                  User
                </MDBDropdownToggle>
                <MDBDropdownMenu>
                  <MDBDropdownItem link>Your workflows</MDBDropdownItem>
                  <MDBDropdownItem link>Your input data</MDBDropdownItem>
                  <MDBDropdownItem link>Logout</MDBDropdownItem>
                </MDBDropdownMenu>
              </MDBDropdown>
            </MDBNavbarItem>
          </MDBNavbarNav>

          {/* <form className='d-flex input-group w-auto'>
            <div className="md-form my-0">
              <input className="form-control mr-sm-2" type="text" placeholder="Search" aria-label="Search" />
            </div>
          </form> */}

        </MDBCollapse>
      </MDBContainer>
    </MDBNavbar>
    </div>
  );
}

// const TabSections = () => {
//   const [iconsActive, setIconsActive] = useState('tab1');

//   const handleIconsClick = (value: string) => {
//     if (value === iconsActive) {
//       return;
//     }
//     setIconsActive(value);
//   };

//   return (
//     <>
//       <MDBTabs className='mb-3'>
//         <MDBTabsItem>
//           <MDBTabsLink onClick={() => handleIconsClick('tab1')} active={iconsActive === 'tab1'}>
//             <MDBIcon fas icon='chart-pie' className='me-2' />Pipelines</MDBTabsLink>
//         </MDBTabsItem>
//         <MDBTabsItem>
//           <MDBTabsLink onClick={() => handleIconsClick('tab2')} active={iconsActive === 'tab2'}>
//             <MDBIcon fas icon='chart-line' className='me-2' /> Subscriptions
//           </MDBTabsLink>
//         </MDBTabsItem>
//         <MDBTabsItem>
//           <MDBTabsLink onClick={() => handleIconsClick('tab3')} active={iconsActive === 'tab3'}>
//             <MDBIcon fas icon='cogs' className='me-2' /> Settings
//           </MDBTabsLink>
//         </MDBTabsItem>
//       </MDBTabs>

//       <MDBTabsContent>
//         <MDBTabsPane open={iconsActive === 'tab1'}>Tab 1 content</MDBTabsPane>
//         <MDBTabsPane open={iconsActive === 'tab2'}>Tab 2 content</MDBTabsPane>
//         <MDBTabsPane open={iconsActive === 'tab3'}>Tab 3 content</MDBTabsPane>
//       </MDBTabsContent>
//     </>
//   );
// }


export default AppHeader;